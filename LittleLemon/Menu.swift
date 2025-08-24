//
//  Menu.swift
//  LittleLemon
//
//  Created by sakersun on 2025/8/15.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("Search menu", text: $searchText)
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            Text("\(dish.title ?? "") - \(dish.price ?? "")")
                            Spacer()
                            if let imgUrl = dish.image,
                                let url = URL(string: imgUrl)
                            {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 8
                                                )
                                            )
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.onAppear {
            getMenuData()
        }
    }

    func getMenuData() {
        PersistenceController.shared.clear()
        let urlStr =
            "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: urlStr) else {

            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in
            if let error = error {
                print("request failed: \(error)")
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(MenuList.self, from: data)
                {
                    for item in decoded.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                    }

                    do {
                        try viewContext.save()
                    } catch {
                        print("save failed.")
                    }
                }
            } else {
                print("no data received")
            }

        }

        task.resume()
    }

    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    Menu().environment(\.managedObjectContext, context)
}
