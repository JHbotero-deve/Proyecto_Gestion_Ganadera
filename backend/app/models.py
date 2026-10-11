from datetime import datetime
from sqlalchemy import DateTime, ForeignKey, String, Text, func, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(120), nullable=False)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(30), default="ganadero", nullable=False)
    farm_id: Mapped[int | None] = mapped_column(ForeignKey("farms.id", ondelete="SET NULL"), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)


class Farm(Base):
    __tablename__ = "farms"

    id: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(120), nullable=False, index=True)
    ubicacion: Mapped[str | None] = mapped_column(String(240), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    animals: Mapped[list["Animal"]] = relationship(back_populates="farm", cascade="all, delete-orphan")


class Animal(Base):
    __tablename__ = "animals"
    __table_args__ = (UniqueConstraint("farm_id", "identificador", name="uq_animal_farm_identifier"),)

    id: Mapped[int] = mapped_column(primary_key=True)
    farm_id: Mapped[int] = mapped_column(ForeignKey("farms.id", ondelete="CASCADE"), index=True, nullable=False)
    identificador: Mapped[str] = mapped_column(String(80), nullable=False)
    nombre: Mapped[str | None] = mapped_column(String(120), nullable=True)
    especie: Mapped[str] = mapped_column(String(80), default="bovino", nullable=False)
    raza: Mapped[str | None] = mapped_column(String(100), nullable=True)
    sexo: Mapped[str | None] = mapped_column(String(20), nullable=True)
    fecha_nacimiento: Mapped[str | None] = mapped_column(String(10), nullable=True)
    estado: Mapped[str] = mapped_column(String(30), default="activo", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    farm: Mapped[Farm] = relationship(back_populates="animals")
    events: Mapped[list["AnimalEvent"]] = relationship(back_populates="animal", cascade="all, delete-orphan")


class AnimalEvent(Base):
    __tablename__ = "animal_events"

    id: Mapped[int] = mapped_column(primary_key=True)
    animal_id: Mapped[int] = mapped_column(ForeignKey("animals.id", ondelete="CASCADE"), index=True, nullable=False)
    tipo: Mapped[str] = mapped_column(String(40), nullable=False)
    fecha: Mapped[str] = mapped_column(String(10), nullable=False)
    responsable: Mapped[str | None] = mapped_column(String(120), nullable=True)
    observaciones: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    animal: Mapped[Animal] = relationship(back_populates="events")
