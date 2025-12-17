@echo off
REM Generate self-signed certificate for local HTTPS server
openssl req -x509 -newkey rsa:2048 -keyout server_key.pem -out server_cert.pem -days 3650 -nodes -subj "/CN=localhost"
echo Certificate generated successfully!
pause
