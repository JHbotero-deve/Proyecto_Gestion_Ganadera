import pydantic


class RegisterIn(pydantic.BaseModel):
    nombre: str = pydantic.Field(min_length=2, max_length=120)
    email: pydantic.EmailStr
    password: str = pydantic.Field(min_length=10, max_length=128)


class LoginIn(pydantic.BaseModel):
    email: pydantic.EmailStr
    password: str
    captcha_token: str | None = pydantic.Field(default=None, min_length=1, max_length=4096)


class AlternateEmailRequest(pydantic.BaseModel):
    email: pydantic.EmailStr


class AlternateEmailConfirm(pydantic.BaseModel):
    code: str = pydantic.Field(pattern=r"^\d{8}$")


class AlternateEmailStatus(pydantic.BaseModel):
    email: pydantic.EmailStr | None
    verified: bool
    pending_email: pydantic.EmailStr | None


class PasswordResetRequest(pydantic.BaseModel):
    email: pydantic.EmailStr


class PasswordResetConfirm(pydantic.BaseModel):
    email: pydantic.EmailStr
    code: str = pydantic.Field(pattern=r"^\d{8}$")
    new_password: str = pydantic.Field(min_length=10, max_length=128)


class TokenOut(pydantic.BaseModel):
    access_token: str
    token_type: str = "bearer"


class UserRead(pydantic.BaseModel):
    id: int
    nombre: str
    email: pydantic.EmailStr
    role: str
    farm_id: int | None
    model_config = pydantic.ConfigDict(from_attributes=True)


class FarmCreate(pydantic.BaseModel):
    nombre: str = pydantic.Field(min_length=2, max_length=120)
    ubicacion: str | None = pydantic.Field(default=None, max_length=240)


class FarmRead(pydantic.BaseModel):
    id: int
    nombre: str
    ubicacion: str | None
    model_config = pydantic.ConfigDict(from_attributes=True)


class AnimalCreate(pydantic.BaseModel):
    farm_id: int
    identificador: str = pydantic.Field(min_length=1, max_length=10)
    nombre: str | None = pydantic.Field(default=None, max_length=60)
    especie: str = pydantic.Field(default="bovino", max_length=80)
    raza: str | None = pydantic.Field(default=None, max_length=50)
    sexo: str | None = pydantic.Field(default=None, max_length=10)
    fecha_nacimiento: str | None = pydantic.Field(default=None, pattern=r"^\d{4}-\d{2}-\d{2}$")


class AnimalPatch(pydantic.BaseModel):
    nombre: str | None = pydantic.Field(default=None, max_length=60)
    raza: str | None = pydantic.Field(default=None, max_length=50)
    sexo: str | None = pydantic.Field(default=None, max_length=10)
    estado: str | None = pydantic.Field(default=None, max_length=30)


class AnimalRead(pydantic.BaseModel):
    id: int
    farm_id: int
    identificador: str
    nombre: str | None
    especie: str
    raza: str | None
    sexo: str | None
    fecha_nacimiento: str | None
    estado: str
    model_config = pydantic.ConfigDict(from_attributes=True)


class EventCreate(pydantic.BaseModel):
    tipo: str = pydantic.Field(min_length=2, max_length=40)
    fecha: str = pydantic.Field(pattern=r"^\d{4}-\d{2}-\d{2}$")
    responsable: str | None = pydantic.Field(default=None, max_length=120)
    observaciones: str | None = pydantic.Field(default=None, max_length=4000)


class EventRead(pydantic.BaseModel):
    id: int
    animal_id: int
    tipo: str
    fecha: str
    responsable: str | None
    observaciones: str | None
    model_config = pydantic.ConfigDict(from_attributes=True)
