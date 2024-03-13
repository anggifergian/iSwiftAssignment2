//
//  WaifuView.swift
//  iSwiftAssignment2
//
//  Created by Anggi Fergian on 28/02/24.
//

import SwiftUI

struct WaifuView: View {
    @StateObject private var waifuVM = WaifuViewModel()
    @State private var searchText = ""
    @State private var isShowingSheet = false
    
    var searchResults: [Waifu] {
        if (searchText.isEmpty) {
            return waifuVM.waifu_list
        } else {
            return waifuVM.waifu_list.filter { waifu in
                return waifu.name.contains(searchText)
            }
        }
    }
    
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(waifuVM.waifu_list) { item in
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: item.image)) { phase in
                                switch phase {
                                case .empty:
                                    WaitView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                case .failure(let error):
                                    VStack {
                                        Image(systemName: "photo.fill")
                                        Text(error.localizedDescription)
                                    }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .sheet(isPresented: $isShowingSheet) {
                                Group {
                                    let DEFAULT_TEXT = "You are about to share this items."
                                    
                                    if let imageToShare = UIImage(named: item.image) {
                                        ActivityView(activityItems: [DEFAULT_TEXT, imageToShare])
                                    } else {
                                        ActivityView(activityItems: [DEFAULT_TEXT])
                                    }
                                }
                                .presentationDetents([.medium, .large])
                            }
                            .contextMenu {
                                Button {
                                    isShowingSheet.toggle()
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }

                            }
                            
                            Text(item.name)
                                .lineLimit(2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                            
                            Text(item.anime)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .task {
                    await waifuVM.fetchPhotos()
                }
            }
            .navigationTitle("Wibu")
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "e.g Your Waifu"
        ) {
            if searchResults.isEmpty {
                ZStack {
                    Text("Create the new one")
                }
            } else {
                ForEach(searchResults) { result in
                    Text(result.name)
                        .searchCompletion(result)
                }
            }
        }
    }
}

struct WaifuView_Previews: PreviewProvider {
    static var previews: some View {
        WaifuView()
    }
}


@ViewBuilder
func WaitView() -> some View {
    VStack(spacing: 20) {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.pink)
    }
}
