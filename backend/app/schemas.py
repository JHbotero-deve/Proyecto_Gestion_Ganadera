from pydantic import BaseModel, ConfigDict, EmailStr, Field


class RegisterIn(BaseModel):
    nombre: str = Field(min_length=2, max_length=120)
    email: EmailStr
    password: str = Field(min_length=10, max_length=128)


class LoginIn(BaseModel):
    email: EmailStr
    password: str


class TokenOut(BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserRead(BaseModel):
    id: int
    nombre: str
    email: EmailStr
    role: str
    farm_id: int | None
    model_config = ConfigDict(from_attributes=True)


class FarmCreate(BaseModel):
    nombre: str = Field(min_length=2, max_length=120)
    ubicacion: str | None = Field(default=None, max_length=240)


class FarmRead(BaseModel):
    id: int
    nombre: str
    ubicacion: str | None
    model_config = ConfigDict(from_attributes=True)


class AnimalCreate(BaseModel):
    farm_id: int
    identificador: str = Field(min_length=1, max_length=80)
    nombre: str | None = Field(default=None, max_length=120)
    especie: str = Field(default="bovino", max_length=80)
    raza: str | None = Field(default=None, max_length=100)
    sexo: str | None = Field(default=None, max_length=20)
    fecha_nacimiento: str | None = Field(default=None, pattern=r"^\d{4}-\d{2}-\d{2}$")


class AnimalPatch(BaseModel):
    nombre: str | None = Field(default=None, max_length=120)
    raza: str | None = Field(default=None, max_length=100)
    sexo: str | None = Field(default=None, max_length=20)
    estado: str | None = Field(default=None, max_length=30)


class AnimalRead(BaseModel):
    id: int
    farm_id: int
    identificador: str
    nombre: str | None
    especie: str
    raza: str | None
    sexo: str | None
    fecha_nacimiento: str | None
    estado: str
    model_config = ConfigDict(from_attributes=True)


class EventCreate(BaseModel):
    tipo: str = Field(min_length=2, max_length=40)
    fecha: str = Field(pattern=r"^\d{4}-\d{2}-\d{2}$")
    responsable: str | None = Field(default=None, max_length=120)
    observaciones: str | None = Field(default=None, max_length=4000)


class EventRead(BaseModel):
    id: int
    animal_id: int
    tipo: str
    fecha: str
    responsable: str | None
    observaciones: str | None
    model_config = ConfigDict(from_attributes=True)
