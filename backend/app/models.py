from datetime import date, datetime
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, ForeignKey, Date, DateTime, Numeric, Boolean, Index
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base

# ENUMS OFICIALES
class UserRole(str, Enum):
    ADMIN = "ADMIN"
    VETERINARIO = "VETERINARIO"
    MAYORDOMO = "MAYORDOMO"

class CattleGender(str, Enum):
    MACHO = "MACHO"
    HEMBRA = "HEMBRA"

class CattleStatus(str, Enum):
    ACTIVO = "ACTIVO"
    VENDIDO = "VENDIDO"
    MUERTO = "MUERTO"
    TRASLADADO = "TRASLADADO"

class EventType(str, Enum):
    VACUNACION = "VACUNACION"
    DESPARASITACION = "DESPARASITACION"
    PESAJE = "PESAJE"
    TRATAMIENTO = "TRATAMIENTO"


# MODELO USUARIOS (RBAC)
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(150), unique=True, index=True, nullable=False)
    full_name: Mapped[str] = mapped_column(String(100), nullable=False)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[UserRole] = mapped_column(default=UserRole.MAYORDOMO, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


# MODELO FINCAS
class Farm(Base):
    __tablename__ = "farms"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    location: Mapped[Optional[str]] = mapped_column(String(150))
    owner_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


# MODELO GANADO / ANIMALES
class Animal(Base):
    __tablename__ = "animals"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    finca_id: Mapped[int] = mapped_column(ForeignKey("farms.id", ondelete="RESTRICT"), nullable=False, index=True)
    tag_id: Mapped[str] = mapped_column(String(50), unique=True, index=True, nullable=False)
    name: Mapped[Optional[str]] = mapped_column(String(100))
    gender: Mapped[CattleGender] = mapped_column(nullable=False)
    birth_date: Mapped[date] = mapped_column(Date, nullable=False)
    breed: Mapped[str] = mapped_column(String(50), nullable=False)
    color: Mapped[Optional[str]] = mapped_column(String(50))
    current_weight: Mapped[float] = mapped_column(Numeric(6, 2), nullable=False)
    status: Mapped[CattleStatus] = mapped_column(default=CattleStatus.ACTIVO, nullable=False)
    
    # Audit log & Soft Delete
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    deleted_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)

    __table_args__ = (
        Index("idx_animal_finca_active", "finca_id", "is_active"),
        Index("idx_animal_status_active", "status", "is_active"),
    )


# MODELO EVENTOS SANITARIOS Y PESAJES
class CattleEvent(Base):
    __tablename__ = "cattle_events"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    animal_id: Mapped[int] = mapped_column(ForeignKey("animals.id", ondelete="RESTRICT"), nullable=False, index=True)
    event_type: Mapped[EventType] = mapped_column(nullable=False)
    event_date: Mapped[date] = mapped_column(Date, nullable=False)
    weight: Mapped[Optional[float]] = mapped_column(Numeric(6, 2))
    description: Mapped[str] = mapped_column(String(255), nullable=False)
    withdrawal_days: Mapped[int] = mapped_column(default=0)
    performed_by_id: Mapped[int] = mapped_column(ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)

    __table_args__ = (
        Index("idx_events_animal_type", "animal_id", "event_type"),
    )


# MODELO CÓDIGOS DE RECUPERACIÓN DE CONTRASEÑA
class PasswordResetCode(Base):
    __tablename__ = "password_reset_codes"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(150), index=True, nullable=False)
    code: Mapped[str] = mapped_column(String(6), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)


# Alias para mantener compatibilidad con env.py de Alembic
AnimalEvent = CattleEvent
