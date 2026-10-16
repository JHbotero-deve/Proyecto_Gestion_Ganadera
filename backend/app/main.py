from contextlib import asynccontextmanager
from fastapi import Depends, FastAPI, HTTPException, status, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.routers import extras, social_auth
from app.routers import extras

from app.config import settings
from app.db import Base, engine, get_db
from app.models import Animal, AnimalEvent, Farm, User
from app.schemas import (
    RegisterIn,
    LoginIn,
    TokenOut,
    UserRead,
    FarmCreate,
    FarmRead,
    AnimalCreate,
    AnimalPatch,
    AnimalRead,
    EventCreate,
    EventRead,
)
from app.security import hash_password, verify_password, create_access_token
from app.deps import current_user


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Solo arranque rápido de desarrollo. En producción, usar migraciones Alembic.
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="Proyecto Gestión Ganadera API",
    version="0.1.0",
    description="API RESTful para la gestión ganadera, fincas, animales e historial de eventos.",
    lifespan=lifespan,
)

if settings.cors_origins:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )


@app.get("/health", tags=["Salud"])
def health():
    return {"status": "ok", "service": "gestion-ganadera-api"}


@app.post("/api/v1/auth/register", response_model=TokenOut, status_code=status.HTTP_201_CREATED, tags=["Autenticación"])
def register(data: RegisterIn, db: Session = Depends(get_db)):
    user = User(
        nombre=data.nombre.strip(),
        email=str(data.email).lower(),
        password_hash=hash_password(data.password),
    )
    db.add(user)
    try:
        db.commit()
        db.refresh(user)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El correo ya está registrado")
    return TokenOut(access_token=create_access_token(user.id))


@app.post("/api/v1/auth/login", response_model=TokenOut, tags=["Autenticación"])
def login(data: LoginIn, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == str(data.email).lower()))
    if user is None or user.password_hash is None or not verify_password(data.password, user.password_hash):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales inválidas")
    return TokenOut(access_token=create_access_token(user.id))


@app.get("/api/v1/auth/me", response_model=UserRead, tags=["Autenticación"])
def get_me(user: User = Depends(current_user)):
    return user


def get_authorized_farm(db: Session, user: User, farm_id: int) -> Farm:
    farm = db.get(Farm, farm_id)
    if farm is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Finca no encontrada")
    if user.farm_id is None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No estás asociado a ninguna finca")
    if user.farm_id != farm_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No tienes acceso a esta finca")
    return farm


@app.get("/api/v1/farms", response_model=list[FarmRead], tags=["Fincas"])
def list_farms(db: Session = Depends(get_db), user: User = Depends(current_user)):
    if user.farm_id is None:
        return []
    query = select(Farm).where(Farm.id == user.farm_id).order_by(Farm.id)
    return db.scalars(query).all()


@app.post("/api/v1/farms", response_model=FarmRead, status_code=status.HTTP_201_CREATED, tags=["Fincas"])
def create_farm(data: FarmCreate, db: Session = Depends(get_db), user: User = Depends(current_user)):
    if user.farm_id is not None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Ya tienes una finca asignada")
    farm = Farm(nombre=data.nombre.strip(), ubicacion=data.ubicacion)
    db.add(farm)
    db.flush()
    user.farm_id = farm.id
    db.commit()
    db.refresh(farm)
    return farm


@app.get("/api/v1/animals", response_model=list[AnimalRead], tags=["Animales"])
def list_animals(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
    user: User = Depends(current_user),
):
    if user.farm_id is None:
        return []
    query = select(Animal).where(Animal.farm_id == user.farm_id).order_by(Animal.id).offset(skip).limit(limit)
    return db.scalars(query).all()


@app.post("/api/v1/animals", response_model=AnimalRead, status_code=status.HTTP_201_CREATED, tags=["Animales"])
def create_animal(data: AnimalCreate, db: Session = Depends(get_db), user: User = Depends(current_user)):
    get_authorized_farm(db, user, data.farm_id)
    animal = Animal(**data.model_dump())
    db.add(animal)
    try:
        db.commit()
        db.refresh(animal)
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya existe un animal con ese identificador en la finca",
        )
    return animal


@app.get("/api/v1/animals/{animal_id}", response_model=AnimalRead, tags=["Animales"])
def get_animal(animal_id: int, db: Session = Depends(get_db), user: User = Depends(current_user)):
    animal = db.get(Animal, animal_id)
    if animal is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Animal no encontrado")
    get_authorized_farm(db, user, animal.farm_id)
    return animal


@app.patch("/api/v1/animals/{animal_id}", response_model=AnimalRead, tags=["Animales"])
def update_animal(animal_id: int, data: AnimalPatch, db: Session = Depends(get_db), user: User = Depends(current_user)):
    animal = db.get(Animal, animal_id)
    if animal is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Animal no encontrado")
    get_authorized_farm(db, user, animal.farm_id)
    for key, value in data.model_dump(exclude_unset=True).items():
        setattr(animal, key, value)
    db.commit()
    db.refresh(animal)
    return animal


@app.get("/api/v1/animals/{animal_id}/events", response_model=list[EventRead], tags=["Eventos"])
def list_events(
    animal_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
    user: User = Depends(current_user),
):
    animal = db.get(Animal, animal_id)
    if animal is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Animal no encontrado")
    get_authorized_farm(db, user, animal.farm_id)
    query = (
        select(AnimalEvent)
        .where(AnimalEvent.animal_id == animal_id)
        .order_by(AnimalEvent.fecha.desc())
        .offset(skip)
        .limit(limit)
    )
    return db.scalars(query).all()


@app.post("/api/v1/animals/{animal_id}/events", response_model=EventRead, status_code=status.HTTP_201_CREATED, tags=["Eventos"])
def create_event(animal_id: int, data: EventCreate, db: Session = Depends(get_db), user: User = Depends(current_user)):
    animal = db.get(Animal, animal_id)
    if animal is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Animal no encontrado")
    get_authorized_farm(db, user, animal.farm_id)
    event = AnimalEvent(animal_id=animal_id, **data.model_dump())
    db.add(event)
    db.commit()
    db.refresh(event)
    return event

app.include_router(extras.router)
app.include_router(social_auth.router)