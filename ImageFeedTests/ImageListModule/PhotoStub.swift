//
//  PhotoStub.swift
//  ImageFeedTests
//
//  Created by SERGEY SHLYAKHIN on 21.03.2023.
//

import XCTest
@testable import ImageFeed

// swiftlint:disable line_length force_unwrapping

extension Photo {
	static var stubPhotos: [Self] {
		[
			.init(
				id: "uYrACAHq6jI",
				size: .init(width: 6016.0, height: 3200.0),
				createdAtString: "19 марта 2023 г.",
				welcomeDescription: "Drone aerial shot of Eiffel Tower garden, Champ de Mars, Paris, France. Filmed in 6K DNG RAW on DJI Inspire 2. Original video: https://youtu.be/REDVbTQxMXo",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679231926688-ef9cdab5ed2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwxfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679231926688-ef9cdab5ed2f?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwxfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "EjQxjS9y6yc",
				size: .init(width: 3960.0, height: 5940.0),
				createdAtString: "20 марта 2023 г.",
				welcomeDescription: "Part of my new cinematic series of photos from Rotterdam.",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679327970394-8593ba86023e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679327970394-8593ba86023e?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwyfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "n2u98ApnzX0",
				size: .init(width: 3619.0, height: 5428.0),
				createdAtString: "20 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679343316332-6b854e892a44?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwzfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679343316332-6b854e892a44?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwzfHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "0u3zMxtK6qc",
				size: .init(width: 5377.0, height: 3361.0),
				createdAtString: "20 марта 2023 г.",
				welcomeDescription: "Journey.",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679345506099-baca3b043efe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw0fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679345506099-baca3b043efe?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw0fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "UjuN5kHdO-I",
				size: .init(width: 6016.0, height: 3200.0),
				createdAtString: "19 марта 2023 г.",
				welcomeDescription: "Drone aerial shot of Triumphal Arch, Paris, France. Filmed in 6K DNG RAW on DJI Inspire 2. Original video: https://youtu.be/REDVbTQxMXo",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679231926885-0287bbe32008?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw1fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679231926885-0287bbe32008?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw1fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "Y97g7CAaEbA",
				size: .init(width: 3919.0, height: 5878.0),
				createdAtString: "19 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679215805563-46bc129ba1a8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw2fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679215805563-46bc129ba1a8?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw2fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "OTHbYRa-QWw",
				size: .init(width: 5793.0, height: 4000.0),
				createdAtString: "20 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679325992705-24defc2382da?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw3fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679325992705-24defc2382da?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw3fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "uLYY0I7glaI",
				size: .init(width: 4000.0, height: 6000.0),
				createdAtString: "19 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679178936583-af19713f2a1c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw4fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679178936583-af19713f2a1c?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw4fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "UO7m63HTv-U",
				size: .init(width: 4496.0, height: 3264.0),
				createdAtString: "19 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679225260270-e64480c8eae4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw5fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679225260270-e64480c8eae4?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHw5fHx8fHx8Mnx8MTY3OTQwNTUwNw&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			),
			.init(
				id: "05t7vrIPU5k",
				size: .init(width: 4016.0, height: 6016.0),
				createdAtString: "21 марта 2023 г.",
				welcomeDescription: "",
				thumbImageURL: .init(string: "https://images.unsplash.com/photo-1679368739385-aa023b0d1e5a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwxMHx8fHx8fDJ8fDE2Nzk0MDU1MDc&ixlib=rb-4.0.3&q=80&w=400")!,
				largeImageURL: .init(string: "https://images.unsplash.com/photo-1679368739385-aa023b0d1e5a?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDQ4MTh8MHwxfGFsbHwxMHx8fHx8fDJ8fDE2Nzk0MDU1MDc&ixlib=rb-4.0.3&q=80")!,
				isLiked: false
			)
		]
	}
}
