# AIE - Alea Iacta EST

AIE to zestaw aplikacji do prowadzenia i organizowania sesji RPG: backend w .NET Web API oraz frontend mobilno-desktopowy w Flutterze. Repozytorium zawiera oba komponenty oraz podstawowe materiały projektowe.

## Struktura repozytorium
- `backend/AIE_backend/AIO_API` – .NET 9 Web API (JWT, EF Core, NLog, Swagger).
- `frontend` – Flutter (Dart) z zasobami UI i konfiguracją wieloplatformową.
- `docs` – miejsce na instrukcje i notatki projektowe.

### Struktura frontendu (feature-first)
- `lib/app` – konfiguracja `MaterialApp`, trasy startowe.
- `lib/core` – layout, utils (np. logger).
- `lib/features/auth|campaigns|characters|dice|home|onboarding` – każda funkcja z warstwami `data` (serwisy/API), `domain` (modele), `presentation/pages` (widoki).

> Uwaga: backend jest obecnie w ścieżce `backend/AIE_backend/AIO_API` (odziedziczone z osobnego repo). Możemy go spłaszczyć do `backend/AIO_API` przy kolejnej iteracji, jeśli chcesz uprościć ścieżki.

## Wymagania
- .NET 9 SDK + `dotnet-ef` global tool
- SQL Server (lub zgodna baza)
- Flutter SDK (zainstalowane zależności dla docelowych platform)

## Szybki start

### Backend
```bash
cd backend/AIE_backend/AIO_API
dotnet restore
# ustaw połączenie w appsettings.(Development.)json -> ConnectionStrings:DefaultConnection
dotnet ef database update   # utworzenie/aktualizacja bazy
dotnet run                  # lub uruchom z IDE
```
Tworząc nową migrację: `dotnet ef migrations add <nazwa>` a następnie `dotnet ef database update`.

### Frontend
```bash
cd frontend
flutter pub get
flutter run    # lub .\\flutter-run.bat na Windows
```

## Dokumentacja
Szczegóły konfiguracji i checklisty dev: `docs/setup.md` (do uzupełniania razem z zespołem).
