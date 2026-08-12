# Smart Travel Journal — User Stories

Lab 1, Step 1. Formato: *As a [type of user], I want [goal] so that [reason].*

1. **As a traveler**, I want to create trips with a title and a date range **so that**
   I can organize my memories by destination.

2. **As a traveler**, I want to add journal entries with text, a mood, a photo and my
   current location **so that** I can capture how I felt at each place.

3. **As a traveler**, I want to see all my journal entries pinned on an interactive map
   **so that** I can revisit where I have been.

4. **As a traveler**, I want to search my trips by title **so that** I can quickly find
   a past adventure.

5. **As a traveler**, I want to view charts of my travel statistics **so that** I can see
   patterns in my journaling habits.

6. **As a traveler**, I want an AI-generated summary of each trip **so that** I can
   quickly recall the highlights without rereading every entry.

7. **As a traveler**, I want the app to stay fully usable when AI features are
   unavailable **so that** I can still record entries on any device.

---

## Copertura

Ogni story mappa su una feature dichiarata nel project walkthrough:

| # | Feature | Dove viene costruita |
|---|---|---|
| 1 | Trip (modello + Trip List) | Lab 2, Lab 4 |
| 2 | JournalEntry con foto, mood, GPS | Lab 2, Lab 4 |
| 3 | Map View con pin | Lab 5 |
| 4 | Ricerca per titolo (`.searchable`) | Lab 4 |
| 5 | Charts tab (Swift Charts) | Lab 6 |
| 6 | Riassunto AI (Foundation Models) | Lab 7 |
| 7 | Fallback quando l'AI non è disponibile | Lab 7 |

La 7 non è una feature ma un requisito di robustezza: il corso insiste che l'AI sia
*progressive enhancement*, con `isAvailable` e contenuto statico di riserva.
Sul simulatore il fallback è il comportamento atteso, non un bug.
