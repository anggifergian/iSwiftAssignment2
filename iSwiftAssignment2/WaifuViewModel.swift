//
//  WaifuViewModel.swift
//  iSwiftAssignment2
//
//  Created by Anggi Fergian on 28/02/24.
//

import Foundation

class WaifuViewModel: ObservableObject {
    @Published var waifu_list: [Waifu] = []
    
    private func loadItems() async throws -> [Waifu] {
        guard let url = URL(string: "https://waifu-generator.vercel.app/api/v1") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let items = try JSONDecoder().decode([Waifu].self, from: data)
        
        return items
    }
    
    func fetchPhotos() async {
        do {
            let loadedItems = try await loadItems()
            
            DispatchQueue.main.async {
                self.waifu_list = loadedItems
            }
        }
        catch {
            print(error)
        }
    }
}
