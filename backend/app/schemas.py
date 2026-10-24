from datetime import date, datetime
from typing import Optional, List
from pydantic import BaseModel, ConfigDict, EmailStr, Field

# SCHEMAS DE USUARIOS
class UserBase(BaseModel):
    email: EmailStr
    full_name: str
    role: str = "MAYORDOMO"

class UserCreate(UserBase):
    password: str

class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

# SCHEMAS DE GANADO
class AnimalBase(BaseModel):
    tag_id: str = Field(..., max_length=50)
    name: Optional[str] = Field(None, max_length=100)
    gender: str = Field(..., pattern="^(MACHO|HEMBRA)$")
    birth_date: date
    breed: str = Field(..., max_length=50)
    color: Optional[str] = Field(None, max_length=50)
    current_weight: float = Field(..., gt=0)
    status: str = "ACTIVO"

class AnimalCreate(AnimalBase):
    finca_id: int

class AnimalUpdate(BaseModel):
    name: Optional[str] = None
    color: Optional[str] = None
    current_weight: Optional[float] = None
    status: Optional[str] = None

class AnimalResponse(AnimalBase):
    id: int
    finca_id: int
    is_active: bool
    created_at: datetime
    updated_at: datetime
    model_config = ConfigDict(from_attributes=True)

# SCHEMAS DE EVENTOS
class EventBase(BaseModel):
    event_type: str = Field(..., pattern="^(VACUNACION|DESPARASITACION|PESAJE|TRATAMIENTO)$")
    event_date: date
    weight: Optional[float] = Field(None, gt=0)
    description: str = Field(..., max_length=255)
    withdrawal_days: int = Field(0, ge=0)

class EventCreate(EventBase):
    animal_id: int

class EventResponse(EventBase):
    id: int
    animal_id: int
    performed_by_id: int
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)
