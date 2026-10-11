def test_animal_events(client):
    token = client.post(
        "/api/v1/auth/register",
        json={"nombre": "User 1", "email": "u1@ganadera.com", "password": "Password123Secure!"},
    ).json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    farm_id = client.post("/api/v1/farms", json={"nombre": "Finca Eventos"}, headers=headers).json()["id"]
    animal_id = client.post(
        "/api/v1/animals",
        json={"farm_id": farm_id, "identificador": "A-01"},
        headers=headers,
    ).json()["id"]

    event_res = client.post(
        f"/api/v1/animals/{animal_id}/events",
        json={
            "tipo": "vacunacion",
            "fecha": "2026-03-01",
            "responsable": "Dr. Perez",
            "observaciones": "Aftosa Dosis 1",
        },
        headers=headers,
    )
    assert event_res.status_code == 201

    events_res = client.get(f"/api/v1/animals/{animal_id}/events", headers=headers)
    assert events_res.status_code == 200
    assert len(events_res.json()) == 1
    assert events_res.json()[0]["tipo"] == "vacunacion"
