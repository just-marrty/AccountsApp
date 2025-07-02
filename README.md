## Transparentní účty ČS – iOS aplikace

Tato nativní iOS aplikace prezentuje transparentní účty České spořitelny na základě veřejně dostupného API. 

## Vytvořeno
- Swift 5.0 
- Xcode 16.4 

## Funkce
- Zobrazení seznamu transparentních účtů
- Vyhledávání podle názvu účtu
- Detail účtu s informacemi o zůstatku, IBANu, popisu a datu aktualizace
- Obnovení dat tažením dolů (pull-to-refresh)
- Řazení účtů podle abecedy (ignoruje whitespace, čísla až na konec)
- Plně napsané ve SwiftUI, s moderním designem
- Optimalizováno pro iPhone (iOS 18.5)

## Použité technologie
- Swift 
- SwiftUI 
- Foundation framework
- MVVM (Model-View-ViewModel)
- REST API (CSAS)
- URLSession
- Environment variables
  
iOS specifické funkce
- UIApplication pro správu klávesnice
- NavigationStack pro navigaci
- ProgressView pro loading stavy
  
**CSAS Developer API** – [developers.erstegroup.com](https://developers.erstegroup.com/)

## Jak spustit
1. Klonuj repozitář
2. Otevři .xcodeproj nebo .xcodeworkspace
3. Vytvoř .env soubor do složky Resources ve formátu:
   
API_KEY=tvuj_klic_z_developers_portalu

5. Spusť na simulátoru nebo reálném zařízení

> .env soubor je ignorován pomocí .gitignore, aby nedošlo ke zveřejnění citlivých údajů.

## Autor
Martin Hrbáček
[https://www.moje-webovka.cz/](https://www.moje-webovka.cz/)

Pokud máte jakékoli dotazy ohledně kódu nebo funkcionality, neváhejte mě kontaktovat.
