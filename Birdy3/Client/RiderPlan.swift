import SwiftUI

struct RidePlan: View {
    @State private var pickup: String = ""
    @State private var destination: String = ""
    @State private var stop1: String? = "789 Oak St, Bethesda, MD"
    @State private var stop2: String? = nil
    @State private var pickupSuggestions: [Suggestion] = [Suggestion(id: "current_location", name: "Current Location")]
    @State private var destinationSuggestions: [Suggestion] = []
    @State private var pickupHeight: CGFloat = 120
    @State private var destinationHeight: CGFloat = 0
    @State private var showDateTimePicker: Bool = false
    @State private var showGuestModal: Bool = false
    @State private var guestName: String = ""
    @State private var isPickupSelected: Bool = false
    @State private var isDestinationSelected: Bool = false
    
    // Mock store data
    @State private var from: String = ""
    @State private var to: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Share Location Button
                Button(action: {
                    withAnimation(.easeOut(duration: 0.15)) {
                        handleShareLocation()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                        Text("Share Location")
                            .font(.custom("Nunito-SemiBold", size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                // Header
                HStack {
                    Image(systemName: "car")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                    Text("Plan your ride")
                        .font(.custom("Nunito-Bold", size: 24))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 20)
                
                // Options
                HStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            showDateTimePicker = true
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.black)
                            Text("Pickup now")
                                .font(.custom("Nunito-Regular", size: 14))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.15)) {
                            showGuestModal = true
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            Text("For me")
                                .font(.custom("Nunito-Regular", size: 14))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                // Input Container
                VStack(spacing: 8) {
                    // Pickup
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.black)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 8)
                        TextField("Pickup location", text: $pickup, onEditingChanged: { editing in
                            if !editing && !isPickupSelected {
                                fetchSuggestions(text: pickup, type: "pickup")
                            }
                        })
                        .font(.custom("Nunito-Regular", size: 14))
                        .padding(8)
                        .onChange(of: pickup) { newValue in
                            isPickupSelected = false
                            fetchSuggestions(text: newValue, type: "pickup")
                        }
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                clearPickup()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                        }
                        .padding(8)
                    }
                    
                    // Pickup Suggestions
                    withAnimation(.easeOut(duration: 0.3)) {
                        VStack {
                            ForEach(pickupSuggestions) { suggestion in
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.15)) {
                                        handlePickupSelect(name: suggestion.name)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: suggestion.id == "current_location" ? "location.fill" : "mappin")
                                            .foregroundColor(.black)
                                            .frame(width: 16, height: 16)
                                        Text(suggestion.name)
                                            .font(.custom("Nunito-Regular", size: 14))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(8)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.gray.opacity(0.2))
                                            .offset(y: 4)
                                    )
                                }
                            }
                        }
                        .frame(height: pickupHeight)
                    }
                    
                    // Stop 1
                    if let stop1 = stop1 {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.black)
                                .frame(width: 16, height: 16)
                                .padding(.trailing, 8)
                            TextField("Stop 1", text: .constant(stop1))
                                .font(.custom("Nunito-Regular", size: 14))
                                .padding(8)
                                .disabled(true)
                            Button(action: {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    clearStop1()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(8)
                        }
                    }
                    
                    // Stop 2
                    if let stop2 = stop2 {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.black)
                                .frame(width: 16, height: 16)
                                .padding(.trailing, 8)
                            TextField("Stop 2", text: .constant(stop2))
                                .font(.custom("Nunito-Regular", size: 14))
                                .padding(8)
                                .disabled(true)
                            Button(action: {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    clearStop2()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(8)
                        }
                    }
                    
                    // Destination
                    HStack {
                        Image(systemName: "square.fill")
                            .foregroundColor(.black)
                            .frame(width: 16, height: 16)
                            .padding(.trailing, 8)
                        TextField("Where to?", text: $destination, onEditingChanged: { editing in
                            if !editing && !isDestinationSelected {
                                fetchSuggestions(text: destination, type: "destination")
                            }
                        })
                        .font(.custom("Nunito-Regular", size: 14))
                        .padding(8)
                        .onChange(of: destination) { newValue in
                            isDestinationSelected = false
                            fetchSuggestions(text: newValue, type: "destination")
                        }
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                clearDestination()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                        }
                        .padding(8)
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.15)) {
                                print("Navigating to RidePlanStops")
                            }
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                        }
                        .padding(8)
                    }
                    
                    // Destination Suggestions
                    withAnimation(.easeOut(duration: 0.3)) {
                        VStack {
                            ForEach(destinationSuggestions) { suggestion in
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.15)) {
                                        handleDestinationSelect(name: suggestion.name)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "mappin")
                                            .foregroundColor(.black)
                                            .frame(width: 16, height: 16)
                                        Text(suggestion.name)
                                            .font(.custom("Nunito-Regular", size: 14))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(8)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.gray.opacity(0.2))
                                            .offset(y: 4)
                                    )
                                }
                            }
                        }
                        .frame(height: destinationHeight)
                    }
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 18)
                
                // Continue Button
                Button(action: {
                    withAnimation(.easeOut(duration: 0.15)) {
                        if from.isEmpty || to.isEmpty {
                            print("Continue button disabled: from or to is empty")
                        } else {
                            print("Navigating to ChooseRide with: from=\(from), to=\(to), stop1=\(stop1 ?? "none"), stop2=\(stop2 ?? "none")")
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.custom("Nunito-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(from.isEmpty || to.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(from.isEmpty || to.isEmpty)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(Color.white)
            .navigationTitle("")
            .navigationBarHidden(true)
            // Modals
            .sheet(isPresented: $showDateTimePicker) {
                VStack {
                    DatePicker("Select Date and Time", selection: .constant(Date()), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.wheel)
                        .padding()
                    Button("Close") {
                        showDateTimePicker = false
                    }
                    .font(.custom("Nunito-Regular", size: 16))
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            .sheet(isPresented: $showGuestModal) {
                VStack(spacing: 10) {
                    Text("Enter Guest Name")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(.black)
                    TextField("Guest name", text: $guestName)
                        .font(.custom("Nunito-Regular", size: 14))
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    HStack {
                        Button("Save") {
                            print("Guest name saved: \(guestName)")
                            showGuestModal = false
                        }
                        .font(.custom("Nunito-Regular", size: 16))
                        Button("Cancel") {
                            showGuestModal = false
                        }
                        .font(.custom("Nunito-Regular", size: 16))
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            // Auto-navigate when from and to are filled
            .onChange(of: from) { _ in checkAndNavigate() }
            .onChange(of: to) { _ in checkAndNavigate() }
            .onChange(of: stop1) { _ in checkAndNavigate() }
            .onChange(of: stop2) { _ in checkAndNavigate() }
            .onAppear {
                if pickup.isEmpty && from.isEmpty {
                    handleShareLocation()
                }
            }
        }
    }
    
    // Helper Functions
    private func fetchSuggestions(text: String, type: String) {
        print("Mock fetchSuggestions for: text=\(text), type=\(type)")
        if type == "pickup" && isPickupSelected {
            pickupSuggestions = []
            pickupHeight = 0
            return
        }
        if type == "destination" && isDestinationSelected {
            destinationSuggestions = []
            destinationHeight = 0
            return
        }
        if text.count < 3 {
            if type == "pickup" {
                pickupSuggestions = [Suggestion(id: "current_location", name: "Current Location")]
                pickupHeight = 120
            } else {
                destinationSuggestions = []
                destinationHeight = 0
            }
            return
        }
        let mockSuggestions = [
            Suggestion(id: "1", name: "123 Main St, Arlington, VA"),
            Suggestion(id: "2", name: "456 Oak St, Bethesda, MD"),
            Suggestion(id: "3", name: "789 Pine St, Washington, DC")
        ]
        if type == "pickup" {
            pickupSuggestions = [Suggestion(id: "current_location", name: "Current Location")] + mockSuggestions
            pickupHeight = 120
        } else {
            destinationSuggestions = mockSuggestions
            destinationHeight = 240
        }
    }
    
    private func handlePickupSelect(name: String) {
        print("Selected pickup: \(name)")
        if name == "Current Location" {
            handleShareLocation()
        } else {
            pickup = name
            from = name
            fetchGeocodeAddress(name, type: "from")
            pickupSuggestions = []
            pickupHeight = 0
            isPickupSelected = true
        }
    }
    
    private func handleDestinationSelect(name: String) {
        destination = name
        to = name
        fetchGeocodeAddress(name, type: "to")
        destinationSuggestions = []
        destinationHeight = 0
        isDestinationSelected = true
    }
    
    private func clearPickup() {
        print("Clearing pickup field")
        pickup = ""
        from = ""
        pickupSuggestions = [Suggestion(id: "current_location", name: "Current Location")]
        pickupHeight = 120
        isPickupSelected = false
    }
    
    private func clearDestination() {
        print("Clearing destination field")
        destination = ""
        to = ""
        destinationSuggestions = []
        destinationHeight = 0
        isDestinationSelected = false
    }
    
    private func clearStop1() {
        print("Clearing stop1 field")
        stop1 = nil
    }
    
    private func clearStop2() {
        print("Clearing stop2 field")
        stop2 = nil
    }
    
    private func handleShareLocation() {
        print("Mock handleShareLocation")
        let address = "5617 Lambert Dr, Cardozo, DC"
        pickup = address
        from = address
        pickupSuggestions = []
        pickupHeight = 0
        fetchGeocodeAddress(address, type: "from")
        isPickupSelected = true
    }
    
    private func checkAndNavigate() {
        if !from.isEmpty && !to.isEmpty {
            print("Fetching geocodes and navigating to ChooseRide with: from=\(from), to=\(to), stop1=\(stop1 ?? "none"), stop2=\(stop2 ?? "none")")
            fetchGeocodeAddress(from, type: "from")
            fetchGeocodeAddress(to, type: "to")
            if let stop1 = stop1 {
                fetchGeocodeAddress(stop1, type: "stop1")
            }
            if let stop2 = stop2 {
                fetchGeocodeAddress(stop2, type: "stop2")
            }
        }
    }
    
    // Mock backend function
    private func fetchGeocodeAddress(_ address: String, type: String) {
        print("Mock fetchGeocodeAddress for: address=\(address), type=\(type)")
    }
}

// Models
struct Suggestion: Identifiable {
    let id: String
    let name: String
}

struct RidePlan_Previews: PreviewProvider {
    static var previews: some View {
        RidePlan()
    }
}
