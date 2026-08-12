import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(TripsViewModel.self) private var tripsViewModel
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Trip.startDate, order: .reverse)
    private var trips: [Trip]

    @State private var showAddTrip = false
    @Namespace private var tripNamespace

    var body: some View {
        @Bindable var vm = tripsViewModel

        NavigationStack {
            List {
                ForEach(vm.filteredTrips(trips)) { trip in
                    NavigationLink {
                        TripDetailView(trip: trip, namespace: tripNamespace)
                    } label: {
                        TripRowView(trip: trip, namespace: tripNamespace)
                    }
                }
                .onDelete { offsets in
                    tripsViewModel.deleteTrips(at: offsets, from: trips, context: modelContext)
                }
            }
            .navigationTitle("My Trips")
            .searchable(text: $vm.searchText, prompt: "Search trips")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("+ Trip") {
                        withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                            showAddTrip = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.accentColor)
                }
            }
            .sheet(isPresented: $showAddTrip) {
                AddTripView()
            }
        }
    }
}
