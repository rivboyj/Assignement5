import SwiftUI

struct Country: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var name: CountryName
    var capital: [String]?
    var flag: String
    var population: Int
    var currencies : [String:CurDetails]?
    
}

struct CountryName: Codable {
    var common: String
    var official: String
}


struct CurDetails: Codable{
    var name: String?
    var symbol: String?
}

struct CountriesView: View {
    @State var countries =  [Country]()
    
    func getAllCountries() async -> () {
        do {
            let url = URL(string: "https://restcountries.com/v3.1/all")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            countries = try JSONDecoder().decode([Country].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                VStack(alignment: .leading) {
                    Text("\(country.flag) • \(country.name.common)")
                }
            }
            .task {
                await getAllCountries()
            }
        }
        .navigationTitle("Countries")
    }
}
struct OneView: View {
    @State var countries =  [Country]()
    
    func getAllCountries() async -> () {
        do {
            let url = URL(string: "https://restcountries.com/v3.1/all")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            countries = try JSONDecoder().decode([Country].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    func fetchCurrencies(currencies: [String:CurDetails]) -> String {
                if let key = currencies.keys.first, //gets first keys in currencies, NZD ex
                    let currencyType = currencies[key] { //gets value of NZD, which is another dictionary, we unpack as curDetails
                    let name = currencyType.name
                    let symbol = currencyType.symbol
                    return "\(name ?? "N/A") \(symbol ?? "N/A")"
                }
                return ""
            }
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                VStack(alignment: .leading) {
                   Text("\(fetchCurrencies(currencies:country.currencies!)) • \(country.name.common)")
                }
            }
            .task {
                await getAllCountries()
            }
        }
        .navigationTitle("Countries")
    }
}

struct MainView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("Image3")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(-1)
                
                // Add a white rectangle at the top
                Rectangle()
                    
                    .fill(Color.white)
                    .frame(height: 90) // Adjust the height as needed
                    .position(x:200,y:-50)
                    .alignmentGuide(.top){_ in 0}
                    .zIndex(0) // Set the zIndex to 0 to place it behind other views
           
                VStack {
                    NavigationLink(destination: CountriesView()) {
                        Text("Go to Countries")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: OneView()) {
                        Text("Go to One View")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .navigationBarTitle("Fun with Countries", displayMode: .inline)
                
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
