# Marvel-Heroes
iOS application, prvoide ability to review marvel charactes and comics, mark them as favorites.
Marver developer portal:
https://developer.marvel.com/docs

Please note that app require Marvel Developer API key.
Known issues - constraint warning, despite on this looks fine at iPhone 11/iPhone 5se.


Comic and character codable structs:
--
 - ./Model/Comics/Codable/Comic.swift
 - ./Model/Comics/Codable/ComicDataContainer.swift
 - ./Model/Comics/Codable/ComicDataWrapper.swift

 - ./Model/Character/Codable/CharacterDataWrapper.swift
 - ./Model/Character/Codable/CharactersContainer.swift
 - ./Model/Character/Codable/Character.swift

Comic and character objects:
--
 - ./Model/Character/Realm/CharacterDataModel.swift
 - ./Model/Comics/Realm/ComicDataModel.swift

Comic and character services, decode from JSON and write to realm:
--
 - ./Model/Comics/ComicService.swift
 - ./Model/Character/CharacterService.swift

Comic and character factory, craete realm objects:
--
 - ./Model/Comics/ComicDataModelFactory.swift
 - ./Model/Character/CharacterDataModelFactory.swift

Custom cell:
--
 - ./Cells/GenericTableViewCellModel.swift
 - ./Cells/GenericTableViewCell.xib
 - ./Cells/GenericTableViewCell.swift

Network layer:
--
 - ./Network/URLHelper/UrlSchema.swift
 - ./Network/URLHelper/UrlPath.swift
 - ./Network/URLHelper/UrlBuilder.swift
 - ./Network/URLHelper/UrlHost.swift
 - ./Network/OperationQueue/DownloadOperation.swift
 - ./Network/OperationQueue/DownloadManager.swift

Tool to hash timestamp and public, private API key, required for any request:
--
 - ./Tools/CryptoHelper.swift

Google firebase:
--
 - ./GoogleService-Info.plist

Views:
--
 - ./View/ComicsViewController.swift
 - ./View/LoginViewController.swift
 - ./View/CharacterViewController.swift
 - ./View/SettingsViewController.swift
 - ./View/ItemDescriptionViewController.swift
 - ./View/FavoriteViewController.swift

 - ./View/Extensions/CharacterVCExtension.swift
 - ./View/Extensions/LoginVCExtension.swift
 - ./View/Extensions/ComicsVСExtension.swift

Preconfigured fonts:
--
 - ./View/Extensions/UIFonts.swift

ViewModels:
--
 - ./ViewModel/CharacterViewModel.swift
 - ./ViewModel/ComicViewModel.swift

