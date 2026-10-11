def test_register_and_login(client):
    reg_payload = {
        "nombre": "Jorge Botero",
        "email": "jorge@ganadera.com",
        "password": "Password123Secure!",
    }
    reg_res = client.post("/api/v1/auth/register", json=reg_payload)
    assert reg_res.status_code == 201
    assert "access_token" in reg_res.json()
    token = reg_res.json()["access_token"]

    dup_res = client.post("/api/v1/auth/register", json=reg_payload)
    assert dup_res.status_code == 409

    login_res = client.post(
        "/api/v1/auth/login",
        json={"email": "jorge@ganadera.com", "password": "Password123Secure!"},
    )
    assert login_res.status_code == 200
    assert "access_token" in login_res.json()

    me_res = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert me_res.status_code == 200
    assert me_res.json()["email"] == "jorge@ganadera.com"
