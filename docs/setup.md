# Setup i notatki projektowe

## Struktura
- backend/AIE_backend/AIO_API – .NET 9 Web API
- frontend – Flutter (Dart)
- docs – dokumentacja pomocnicza

## Backend (.NET)
1. cd backend/AIE_backend/AIO_API
2. dotnet restore
3. Skonfiguruj ConnectionStrings:DefaultConnection w `appsettings.Development.json` (lub `appsettings.json`).
4. dotnet ef database update   # przygotowanie bazy
5. dotnet run                  # uruchomienie API

Migracje:
- Nowa migracja: `dotnet ef migrations add <nazwa>`
- Aktualizacja bazy: `dotnet ef database update`

## Frontend (Flutter)
1. cd frontend
2. flutter pub get
3. flutter run (lub `.\\flutter-run.bat`)

Budowanie na produkcję:
- Android: `flutter build apk`
- Web: `flutter build web`

## Dalsze porządki / TODO
- Rozważyć spłaszczenie backendu do `backend/AIO_API` dla prostszych ścieżek.
- Dodać opis architektury (warstwy API, modele, routing) i diagram przepływów auth.
- Ustalić listę env varów i sekretów do CI/CD.
