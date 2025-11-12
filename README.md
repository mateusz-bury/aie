# AIE - Alea Iacta EST

![AIE Logo](frontend/assets/images/aie.png)  

## Opis

**AIE - Alea Iacta EST** to nowoczesna aplikacja do zarządzania sesjami RPG, która pomaga prowadzić kampanie, logować postępy i organizować postacie graczy.  
Projekt powstał, by ułatwić Mistrzom Gry i graczom prowadzenie sesji w sposób prosty i intuicyjny, zarówno online, jak i offline.

---

## Funkcjonalności

- Rejestracja i logowanie użytkowników  
- Różne role użytkowników: administrator, gracz, mistrz gry
- Tworzenie i zarządzanie sesjami RPG  
- Panel użytkownika z danymi i historią sesji  
- Intuicyjny interfejs z gradientowym layoutem i responsywnym designem  
- Rzucanie wirtualnymi kostkami z animacjami  
- Backend w C# Web API (w oddzielnym folderze `backend`)  
- Frontend Flutter (w folderze `frontend`)

---

## Technologia

- **Frontend:** Flutter (Dart)  
- **Backend:** C# (.NET Web API)  
- **Baza danych:** [SQL Server]  
- **Kontrola wersji:** Git + GitHub

---

## Instalacja i uruchomienie

### Backend (.NET Web API)

1. Należy pobrać repozytorium 

Frontend:
```bash
   git clone https://github.com/mateusz-bury/aie.git
```
Backend:
```bash
   git https://github.com/JakubCepielik/AIE_backend
```

2. W folderze ./backend w należy uruchomić rozwiązanie AIO_API.sln
3. W PowerShellu należy stworzyć plik mi gracyjny i założyć bazę danych
```pwsh
   add-migration
```
```pwsh
   update-database
```
4. Uruchamiamy Program.cs
   
### Frontend (Flutter Dart)

1. W folderze ./frontend uruchamiamy komende
```bash
   .\flutter-run
```
