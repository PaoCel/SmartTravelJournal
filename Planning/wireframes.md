# Smart Travel Journal — Wireframe

Low-fidelity: contano struttura e posizione, non i colori.
Per ogni schermata, i container SwiftUI previsti.

## 1. Trip List — tab 1

```
┌─────────────────────────────┐
│ Trips                       │  navigationTitle
│ ┌─────────────────────────┐ │
│ │ 🔍 Search               │ │  .searchable()
│ └─────────────────────────┘ │
│ ┌────┐ Tokyo 2026          │
│ │IMG │ 12–22 Apr · 8 entries│  riga: cover + titolo + date + conteggio
│ └────┘                     │
│ ┌────┐ Lisbona             │
│ │IMG │ 3–9 Giu · 5 entries │
│ └────┘                     │
│                    [+ Trip] │  toolbar, top-right
├─────────────────────────────┤
│   Trips  │   Map  │ Charts  │  TabView
└─────────────────────────────┘
```

**Container:** `NavigationStack`, `List`, `TabView`, `.searchable()`

## 2. Trip Detail — push da Trip List

```
┌─────────────────────────────┐
│ ‹ Trips          [+ Add Entry]
│ ┌─────────────────────────┐ │
│ │ Tokyo 2026              │ │  header card
│ │ 12–22 Apr · 8 entries   │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ AI Trip Summary         │ │  placeholder finché non c'è
│ │ (Foundation Models)     │ │  almeno una entry
│ └─────────────────────────┘ │
│ 😀 Primo giorno            │
│    "Arrivati con il..."     │  preview del testo
│    12 Apr  #food #città     │  tag chips
│ 😌 Mercato di Tsukiji       │
│    "Colazione alle 5..."    │
│    13 Apr  #food            │
└─────────────────────────────┘
```

Entry ordinate per timestamp.

**Container:** `NavigationStack` (pushed), `ScrollView`, `List` o `LazyVStack`

## 3. Journal Entry Editor — modale

```
┌─────────────────────────────┐
│ Nuova voce           [Save] │
│ ── Titolo ────────────────  │  Section
│ [ Mercato di Tsukiji      ] │  TextField riga singola
│ ── Testo ─────────────────  │
│ [                         ] │  TextField multilinea
│ [                         ] │
│ ── Mood ──────────────────  │
│ ( 😀 )( 😌 )( 🤩 )( 😢 )( 😴 )│  Happy Calm Excited Sad Tired
│ ── Posizione ─────────────  │
│  35.6762, 139.6503          │  GPS rilevato in automatico
│ ── Data ──────────────────  │
│ [ 13 Apr 2026    ▾ ]        │  DatePicker
│ ── Foto ──────────────────  │
│ [img][img][img]             │  LazyVGrid, dall'asset catalog
│ [img][img]                  │  tap = seleziona
└─────────────────────────────┘
```

**Container:** `Form`, `Section`, `TextField`, `DatePicker`, `LazyVGrid`

## 4. Map View — tab 2

```
┌─────────────────────────────┐
│                    [Style ▾]│  Standard / Imagery / Hybrid
│      📍😀                    │  pin colorato per mood
│           📍😌               │
│                             │  mappa a tutto schermo
│    📍🤩                      │
│ ┌─────────────────────────┐ │
│ │ 8 entries visible       │ │  overlay card in basso
│ └─────────────────────────┘ │
├─────────────────────────────┤
│   Trips  │   Map  │ Charts  │
└─────────────────────────────┘
```

**Container:** `Map`, `Marker`, `Annotation`, `Picker`, `.mapStyle`

---

## Note di struttura

- Tre tab: **Trips**, **Map**, **Charts**, dentro un'unica `TabView`.
- Trip List → Trip Detail è una push dentro `NavigationStack`.
  L'Entry Editor è presentato modale, non in push.
- Il colore del pin sulla mappa deriva dal mood della entry: è l'unico punto in cui
  mood ha un effetto visivo fuori dalla entry stessa.
