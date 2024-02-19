import Foundation

var greeting = "Hello, playground"

let json =
"""
{
    "code": 200,
    "status": "Ok",
    "copyright": "© 2023 MARVEL",
    "attributionText": "Data provided by Marvel. © 2023 MARVEL",
    "etag": "3c3fb5edacebe72839f805923178c4832032d9d3",
    "data": {
        "offset": 10,
        "limit": 20,
        "total": 1,
        "count": 1,
        "results": [
            {
                "id": 1945,
                "title": "Avengers: The Initiative (2007 - 2010)",
                "description": null,
                "resourceURI": "http://gateway.marvel.com/v1/public/series/1945",
                "urls": [
                    {
                        "type": "detail",
                        "url": "http://marvel.com/comics/series/1945/avengers_the_initiative_2007_-_2010?utm_campaign=apiRef&utm_source=19ebd69fcbd349517059711384948e26"
                    }
                ],
                "startYear": 2007,
                "endYear": 2010,
                "rating": "T",
                "type": "",
                "modified": "2013-03-20T17:51:27-0400",
                "thumbnail": {
                    "path": "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/514a2ed3302f5",
                    "extension": "jpg"
                },
                "creators": {
                    "available": 34,
                    "collectionURI": "http://gateway.marvel.com/v1/public/series/1945/creators",
                    "items": [
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/9018",
                            "name": "Mahmud Asrar",
                            "role": "penciller"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/1133",
                            "name": "Stefano Caselli",
                            "role": "penciller"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/1400",
                            "name": "Bong Dazo",
                            "role": "penciller"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/4981",
                            "name": "Steve Kurth",
                            "role": "penciller"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/9368",
                            "name": "Roger Bonet",
                            "role": "inker"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/10091",
                            "name": "Rebecca Buchman",
                            "role": "inker"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/548",
                            "name": "Andrew Hennessy",
                            "role": "inker"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/2133",
                            "name": "Tom Brevoort",
                            "role": "editor"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/694",
                            "name": "Mark Brooks",
                            "role": "penciller (cover)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/357",
                            "name": "Jim Cheung",
                            "role": "penciller (cover)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/10072",
                            "name": "Matteo De Longis",
                            "role": "penciller (cover)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/1054",
                            "name": "Juan Doe",
                            "role": "penciller (cover)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/452",
                            "name": "Virtual Calligr",
                            "role": "letterer"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/13586",
                            "name": "Joe Caramagna",
                            "role": "letterer"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/5251",
                            "name": "Vc Joe Caramagna",
                            "role": "letterer"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/12581",
                            "name": "Chris Eliopoulos",
                            "role": "letterer"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/430",
                            "name": "Edgar Delgado",
                            "role": "colorist"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/8949",
                            "name": "Luca Malisan",
                            "role": "colorist"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/1405",
                            "name": "Matt Milla",
                            "role": "colorist"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/creators/11765",
                            "name": "Christos Gage",
                            "role": "writer"
                        }
                    ],
                    "returned": 20
                },
                "characters": {
                    "available": 71,
                    "collectionURI": "http://gateway.marvel.com/v1/public/series/1945/characters",
                    "items": [
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011334",
                            "name": "3-D Man"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010802",
                            "name": "Ant-Man (Eric O'Grady)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009165",
                            "name": "Avengers"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009175",
                            "name": "Beast"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010829",
                            "name": "Bengal"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009180",
                            "name": "Beta-Ray Bill"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010325",
                            "name": "Betty Brant"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009189",
                            "name": "Black Widow"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010371",
                            "name": "Boomerang"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009220",
                            "name": "Captain America"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010338",
                            "name": "Captain Marvel (Carol Danvers)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010823",
                            "name": "Cloud 9"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009245",
                            "name": "Constrictor"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009267",
                            "name": "Dazzler"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009268",
                            "name": "Deadpool"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010717",
                            "name": "Debrii"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009274",
                            "name": "Diamondback (Rachel Leighton)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009284",
                            "name": "Dum Dum Dugan"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009316",
                            "name": "Gauntlet (Joseph Green)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010731",
                            "name": "Gorilla Man"
                        }
                    ],
                    "returned": 20
                },
                "stories": {
                    "available": 90,
                    "collectionURI": "http://gateway.marvel.com/v1/public/series/1945/stories",
                    "items": [
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/8381",
                            "name": "Avengers: The Initiative (2007) #1",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/8382",
                            "name": "Interior #8382",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/8705",
                            "name": "AVENGERS: THE INITIATIVE (2007) #2",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/8706",
                            "name": "2 of 6 - 6XLS; THE INITIATIVE BANNER",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/32405",
                            "name": "AVENGERS: THE INITIATIVE (2007) #3",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/32406",
                            "name": "Avengers: The Initiative (2007) #3 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/32626",
                            "name": "AVENGERS: THE INITIATIVE (2007) #4",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/32627",
                            "name": "Avengers: The Initiative (2007) #4 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33014",
                            "name": "Avengers: The Initiative (2007) #5",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33015",
                            "name": "Avengers: The Initiative (2007) #5 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33361",
                            "name": "Avengers: The Initiative (2007) #6",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33362",
                            "name": "Avengers: The Initiative (2007) #6 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33363",
                            "name": "AVENGERS: THE INITIATIVE (2007) #7",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/33364",
                            "name": "Avengers: The Initiative (2007) #7 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/36469",
                            "name": "AVENGERS: THE INITIATIVE (2007) #8",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/36470",
                            "name": "Avengers: The Initiative (2007) #8 - Int",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/36907",
                            "name": "AVENGERS: THE INITIATIVE (2007) #9",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/36908",
                            "name": "Killed in Action 1 of 1",
                            "type": "interiorStory"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/44343",
                            "name": "AVENGERS: THE INITIATIVE (2007) #10",
                            "type": "cover"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/stories/44344",
                            "name": "Avengers: The Initiative (2007) #10 - Int",
                            "type": "interiorStory"
                        }
                    ],
                    "returned": 20
                },
                "comics": {
                    "available": 42,
                    "collectionURI": "http://gateway.marvel.com/v1/public/series/1945/comics",
                    "items": [
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/6232",
                            "name": "Avengers: The Initiative (2007) #1"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21843",
                            "name": "Avengers: The Initiative (2007) #1 (50/50 Cover (left))"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21844",
                            "name": "Avengers: The Initiative (2007) #1 (50/50 Cover (right))"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/13489",
                            "name": "Avengers: The Initiative (2007) #2"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/15869",
                            "name": "Avengers: The Initiative (2007) #3"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/15976",
                            "name": "Avengers: The Initiative (2007) #4"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/16162",
                            "name": "Avengers: The Initiative (2007) #5"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/16542",
                            "name": "Avengers: The Initiative (2007) #6"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/16543",
                            "name": "Avengers: The Initiative (2007) #7"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/17397",
                            "name": "Avengers: The Initiative (2007) #8"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/17638",
                            "name": "Avengers: The Initiative (2007) #9"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/20679",
                            "name": "Avengers: The Initiative (2007) #10"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/20877",
                            "name": "Avengers: The Initiative (2007) #11"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21012",
                            "name": "Avengers: The Initiative (2007) #12"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21226",
                            "name": "Avengers: The Initiative (2007) #13"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21366",
                            "name": "Avengers: The Initiative (2007) #14"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/24571",
                            "name": "Avengers: The Initiative (2007) #14 (SPOTLIGHT VARIANT)"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21546",
                            "name": "Avengers: The Initiative (2007) #15"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21741",
                            "name": "Avengers: The Initiative (2007) #16"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/comics/21975",
                            "name": "Avengers: The Initiative (2007) #17"
                        }
                    ],
                    "returned": 20
                },
                "events": {
                    "available": 5,
                    "collectionURI": "http://gateway.marvel.com/v1/public/series/1945/events",
                    "items": [
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/events/318",
                            "name": "Dark Reign"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/events/255",
                            "name": "Initiative"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/events/269",
                            "name": "Secret Invasion"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/events/273",
                            "name": "Siege"
                        },
                        {
                            "resourceURI": "http://gateway.marvel.com/v1/public/events/277",
                            "name": "World War Hulk"
                        }
                    ],
                    "returned": 5
                },
                "next": null,
                "previous": null
            }
        ]
    }
}
"""

//struct Response: Decodable {
//    
//    struct Data: Decodable {
//        let offset: Int
//        let results: [Result]
//        
//        struct Result: Decodable {
//            let title: String
//            let thumbnail: Thumbnail
//            
//            struct Thumbnail: Decodable {
//                let path: String
//                let `extension`: String
//                
//                var value: URL {
//                    URL(string: "\(path).\(`extension`)")!
//                }
//            }
//        }
//    }
//    let data: Data
//}

struct Response: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let heroes: [Hero]
        
        private enum CodingKeys : String, CodingKey {
            case heroes = "results"
        }
        
        struct Hero: Decodable {
            let name: String?
            let description: String?
            let thumbnail: Thumbnail?
            let stories: Category?
            let comics: Category?
            let events: Category?
            let series: Category?
            
            var imageData: Data?
            var descriptionsLoaded: Bool = false
            
            private enum CodingKeys : String, CodingKey {
                case name = "title", description, thumbnail, stories, comics,
                     events, series
            }
            
            mutating func setHeroImage(image: Data) {
                self.imageData = image
            }
            
            struct Thumbnail: Decodable {
                let path: String
                let `extension`: String
                
                var imageURL: URL {
                    URL(string: "\(path).\(`extension`)")!
                }
            }
            
            struct Category: Decodable {
                let items: [Item]
                
                struct Item: Decodable {
                    let resourceURI: String
                    let name: String
                    var description: String?
                    
                    mutating func setDescription(_ description: String?) {
                        self.description = description
                    }
                }
            }
        }
    }
}

let jsonData = json.data(using: .utf8)!

let response = try JSONDecoder().decode(Response.self, from: jsonData)



print(response.data.heroes.flatMap { $0.description })

// MARK: - Code from Nuno
//    struct DAta1 {
//        struct Results {
//
//            struct Comic: Decodable {
//                let name: String
//            }
//
//            let commics: Comic
//
//        }
//
//        let results: [Results]
//    }
//
//
//    {
//        "data1": {
//        results: [
//            {"name": "Ola", age: 1}
//            {"name": "Ola", age: 1}
//            {"name": "Ola", age: 1}
//
//
//        }
//    }
