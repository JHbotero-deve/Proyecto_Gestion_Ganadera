def test_animal_crud(client):
    token = client.post(
        "/api/v1/auth/register",
        json={"nombre": "User 1", "email": "u1@ganadera.com", "password": "Password123Secure!"},
    ).json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    farm_id = client.post("/api/v1/farms", json={"nombre": "Finca Central"}, headers=headers).json()["id"]

    animal_res = client.post(
        "/api/v1/animals",
        json={
            "farm_id": farm_id,
            "identificador": "CO-101",
            "nombre": "Mariposa",
            "especie": "bovino",
            "raza": "Holstein",
            "sexo": "hembra",
            "fecha_nacimiento": "2023-05-10",
        },
        headers=headers,
    )
    assert animal_res.status_code == 201
    animal_id = animal_res.json()["id"]

    dup_res = client.post(
        "/api/v1/animals",
        json={"farm_id": farm_id, "identificador": "CO-101", "nombre": "Otra Mariposa"},
        headers=headers,
    )
    assert dup_res.status_code == 409

    get_res = client.get(f"/api/v1/animals/{animal_id}", headers=headers)
    assert get_res.status_code == 200
    assert get_res.json()["identificador"] == "CO-101"

    patch_res = client.patch(f"/api/v1/animals/{animal_id}", json={"estado": "vendido"}, headers=headers)
    assert patch_res.status_code == 200
    assert patch_res.json()["estado"] == "vendido"
