
import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
import DiiaCommonServices

final class ConstructorMockV2Presenter: ConstructorScreenPresenter, ContextMenuConfigurable {
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let bag = DisposeBag()
    
    private var didRetry = false
    private var inputData: [String: AnyCodable] = [:]
    
    private var json: String?
    
    // MARK: - Init
    init(view: ConstructorScreenViewProtocol,
         json: String?,
         contextMenuProvider: ContextMenuProviderProtocol) {
        self.view = view
        self.contextMenuProvider = contextMenuProvider
        self.json = json
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setHeader(headerContext: contextMenuProvider)
        if json != nil {
            mockFetchFromJson()
        } else {
            mockFetch()
        }
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        case .buttonAction(let parameters, let viewModel):
            actionTapped(action: parameters, actionViewModel: viewModel)
        case .inputChanged(let constructorInputModel):
            inputData[constructorInputModel.inputCode] = constructorInputModel.inputData
            if constructorInputModel.inputCode == "jsonText" {
                self.json = constructorInputModel.inputData?.stringValue() ?? "{}"
            }
            view.inputFieldsWasUpdated()
        case .phoneCodeAction(let viewModel):
            let items = viewModel.codes.map {
                SearchItemModel(
                    code: $0.id,
                    title: $0.description
                )
            }

            let module = SingleSelectionModule(items: items) { [weak viewModel] item in
                viewModel?.currentPhoneCode.value = viewModel?.codes.first(where: { $0.id == item.code })
            }

            view.open(module: module)
        default:
            if let parameters = event.actionParameters() {
                actionTapped(action: parameters)
            }
        }
    }
    
    // MARK: - Private Methods
    private func actionTapped(action: DSActionParameter?, actionViewModel: DSLoadingButtonViewModel? = nil) {
        switch action?.type {
        case "back":
            view.closeModule(animated: true)
        case "openJson":
            if let json = json {
                view.open(module: ConstructorMockV2Module(json: json, contextMenuProvider: contextMenuProvider))
            }
        default:
            log(String(describing: action?.type))
        }
    }
    
    private func mockFetch() {
        view.setLoadingState(.loading)
        onMainQueueAfter(time: 0.5) { [weak self] in
            guard let self = self else { return }
            let model = self.buildMockModel()
            self.view.configure(model: model)
            self.updateContextMenu(model: model, in: &self.contextMenuProvider)
            self.view.setLoadingState(.ready)
        }
    }
    
    private func mockFetchFromJson() {
        view.setLoadingState(.loading)
        onMainQueueAfter(time: 1) {
            let model = self.buildModelFromJSON()
            self.view.configure(model: model)
            self.updateContextMenu(model: model, in: &self.contextMenuProvider)
            self.view.setLoadingState(.ready)
        }
    }
    
    private func buildModelFromJSON() -> DSConstructorModel {
        if let json = json, let constructorModel: DSConstructorModel = json.parseDecodable() {
            return constructorModel
        }
        return buildMockModel()
    }
    
    private func buildMockModel() -> DSConstructorModel {
        var welcomeTitle = R.Strings.authorization_welcome.localized()
        
        let questionForm = DSQuestionFormsModel(
            componentId: "1",
            id: "1",
            title: nil,
            condition: nil,
            items: [
                .dictionary(["inputTextMultilineMlc": .fromEncodable(
                    encodable: DSInputTextMultilineMlc(
                        componentId: nil,
                        inputCode: "jsonText",
                        label: "Введіть json для відображення",
                        placeholder: nil,
                        hint: nil,
                        value: json ?? mockJson,
                        mandatory: nil,
                        validation: nil))
                ])
            ])
        
        return DSConstructorModel(
            topGroup: [
                .dictionary(["topGroupOrg": (.fromEncodable(encodable: DSTopGroupOrg(navigationPanelMlc: .init(label: welcomeTitle, ellipseMenu: nil))))])
            ],
            body: [
                .dictionary([
                    "questionFormsOrg": .fromEncodable(encodable: questionForm)
                ])
            ],
            bottomGroup: [
                .dictionary([
                    "btnPrimaryDefaultAtm": .fromEncodable(encodable: DSButtonModel(label: "Відобразити JSON",
                                                                                    action: .init(type: "openJson"),
                                                                                    componentId: nil))
                ])
            ],
            ratingForm: nil
        )
    }
}

private let mockJson = """
{
  "topGroup" : [
    {
      "topGroupOrg" : {
        "titleGroupMlc" : {
          "heroText" : "Привіт, Надія 👋"
        }
      }
    }
  ],
  "body" : [
    {
      "sectionTitleAtm" : {
        "label" : "Нові повідомлення"
      }
    },
    {
      "smallNotificationCarouselOrg" : {
        "items" : [
          {
            "smallNotificationMlc" : {
              "action" : {
                "type" : "newDeviceConnecting",
                "resource" : "d4b81c8cec2b001310324b91a7dc04fe2a0a5ba6cc8a2136f356c2f05944feb8ff11a2b5e2f185d2bd5a331e0c48d47dd9a55e6a34967bd4908323fce2f7104f"
              },
              "label" : "Зверніть увагу",
              "id" : "e0f6f1ae5f165ab930aadc1b3b6975fc1b73c001da2eda4d78ad5b88cfddf2f3af12f387c917c7328bda0c002969eaf8402dcc06a4e29e75605cbb6abe535480",
              "accessibilityDescription" : "Зверніть увагу\nДо вашої Дії підключено новий пристрій",
              "text" : "До вашої Дії підключено новий пристрій"
            }
          },
          {
            "smallNotificationMlc" : {
              "action" : {
                "type" : "newDeviceConnecting",
                "resource" : "bd16f20827a79fca47ce2535ed94272a65d45325ddf2f0550489896a1db70c4fb28a623c720bbb9b16cc2a5b5df6c277122b1870b3483014d8095ff8b225b82d"
              },
              "label" : "Зверніть увагу",
              "id" : "9eb186764254126f05d78cce746ad5e5fee7b858b62d4472bd1e27c26fad6e419b4001eb8d6678093fde4c0489615fffdae29f1ac734fb99e4e34d2d1bef17f4",
              "accessibilityDescription" : "Зверніть увагу\nДо вашої Дії підключено новий пристрій",
              "text" : "До вашої Дії підключено новий пристрій"
            }
          },
          {
            "smallNotificationMlc" : {
              "action" : {
                "type" : "newDeviceConnecting",
                "resource" : "500aed00040580210e405abba073f32a59417d378787ec2d0d0f25af13ba38df4c121468b7ed31133b4e3376e099bef8a717bbc9bb64657442b6e4505f443eb3"
              },
              "label" : "Зверніть увагу",
              "id" : "ab36fa6028d08d0381931b6b1c4218a966686ca9e91de028788abf3f39fe8109ce930398e5949c5be9f8a741ef46773964ea848048d2a1699ee05a1feb4f9532",
              "accessibilityDescription" : "Зверніть увагу\nДо вашої Дії підключено новий пристрій",
              "text" : "До вашої Дії підключено новий пристрій"
            }
          },
          {
            "iconCardMlc" : {
              "label" : "Всі повідомлення",
              "iconLeft" : "notificationNew",
              "action" : {
                "type" : "allMessages"
              }
            }
          }
        ],
        "dotNavigationAtm" : {
          "count" : 4
        }
      }
    },
    {
      "whiteCardMlc" : {
        "action" : {
          "type" : "invincibilityPoints"
        },
        "doubleIconAtm" : {
          "code" : "safetyLarge"
        },
        "title" : "Незламність",
        "label" : "Мапа Пунктів Незламності та укриттів.\nЗаява про відсутній звʼязок.",
        "accessibilityDescription" : "Незламність\nМапа Пунктів Незламності та укриттів.\nЗаява про відсутній звʼязок.",
        "smallIconAtm" : {
          "code" : "ellipseArrowRight"
        }
      }
    },
    {
      "btnIconRoundedGroupOrg" : {
        "items" : [
          {
            "btnIconRoundedMlc" : {
              "label" : "Сканувати QR-код",
              "icon" : "qrScanWhite",
              "action" : {
                "type" : "qr"
              }
            }
          },
          {
            "btnIconRoundedMlc" : {
              "label" : "Військові облігації",
              "icon" : "tridentWhite",
              "action" : {
                "type" : "militaryBonds"
              }
            }
          },
          {
            "btnIconRoundedMlc" : {
              "label" : "Відсутній звʼязок",
              "icon" : "failedConnection",
              "action" : {
                "type" : "failedConnection"
              }
            }
          }
        ]
      }
    },
    {
      "imageCardMlc" : {
        "iconRight" : "ellipseWhiteArrowRight",
        "label" : "Змінити хід подій",
        "imageAltText" : "Ініціатива президента лінія дронів",
        "image" : "https://api2.diia.gov.ua/ZzTj5gLXnaW8u0s0/smart-mobilization/drones-line.png",
        "action" : {
          "type" : "smartMobilization"
        }
      }
    },
    {
      "sectionTitleAtm" : {
        "label" : "Що нового?"
      }
    },
    {
      "halvedCardCarouselOrg" : {
        "items" : [
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "15 грудня, 12:30\nОберіть фіналіста Нацвідбору на Євробачення-2024 в Дії",
              "label" : "15 грудня, 12:30",
              "title" : "Оберіть фіналіста Нацвідбору на Євробачення-2024 в Дії",
              "image" : "https://api2t.diia.gov.ua/img/diia-news/uploads/public/657/c29/7a7/657c297a776a1886429868.png",
              "action" : {
                "type" : "news",
                "resource" : "20"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "14 грудня, 15:21\nРозширюємо програму єВідновлення: подати заяву про допомогу за пошкоджене житло можна на порталі Дія, через ЦНАП та нотаріусів",
              "label" : "14 грудня, 15:21",
              "title" : "Розширюємо програму єВідновлення: подати заяву про допомогу за пошкоджене житло можна на порталі Дія, через ЦНАП та нотаріусів",
              "image" : "https://api2t.diia.gov.ua/img/diia-news/uploads/public/657/b00/951/657b00951a939914149240.jpg",
              "action" : {
                "type" : "news",
                "resource" : "19"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "12 грудня, 17:32\newtttt",
              "label" : "12 грудня, 17:32",
              "title" : "ewtttt",
              "image" : "https://news-diiastage-3dc.diia.digital/img/diia-news/uploads/public/657/87c/f67/65787cf67e7f8146733022.png",
              "action" : {
                "type" : "news",
                "resource" : "12"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "05 грудня, 14:45\nєЩОСЬ1: подавайте заяву про ремонт пошкодженого житла",
              "label" : "05 грудня, 14:45",
              "title" : "єЩОСЬ1: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
              "action" : {
                "type" : "news",
                "resource" : "test-id-100"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "04 грудня, 14:45\nєШтрафиПДР+СУД: подавайте заяву про ремонт пошкодженого житла",
              "label" : "04 грудня, 14:45",
              "title" : "єШтрафиПДР+СУД: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://diia.gov.ua/storage/app/uploads/public/62b/062/6a7/thumb_643_730_410_0_0_auto.png",
              "action" : {
                "type" : "news",
                "resource" : "test-id-10"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "01 грудня, 14:45\nєХТОМИ: подавайте заяву про ремонт пошкодженого житла",
              "label" : "01 грудня, 14:45",
              "title" : "єХТОМИ: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://api2.diia.gov.ua/diia-images/docPhoto-yalta.png",
              "action" : {
                "type" : "news",
                "resource" : "test-id-5"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "01 грудня, 14:45\nєДІЯ: подавайте заяву про ремонт пошкодженого житла",
              "label" : "01 грудня, 14:45",
              "title" : "єДІЯ: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://api2.diia.gov.ua/diia-images/docPhoto-yalta.png",
              "action" : {
                "type" : "news",
                "resource" : "test-id-4"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "01 грудня, 14:45\nєЗаощадженняяяяяя: подавайте заяву про ремонт пошкодженого житла",
              "label" : "01 грудня, 14:45",
              "title" : "єЗаощадженняяяяяя: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://diia.gov.ua/storage/app/uploads/public/62b/062/6a7/thumb_643_730_410_0_0_auto.png",
              "action" : {
                "type" : "news",
                "resource" : "test-id-3"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "27 листопада, 14:45\nєВідновлення: подавайте заяву про ремонт пошкодженого житла",
              "label" : "27 листопада, 14:45",
              "title" : "єВідновлення: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
              "action" : {
                "type" : "news",
                "resource" : "test-id-id"
              }
            }
          },
          {
            "halvedCardMlc" : {
              "accessibilityDescription" : "27 листопада, 14:45\nє3: подавайте заяву про ремонт пошкодженого житла",
              "label" : "27 листопада, 14:45",
              "title" : "є3: подавайте заяву про ремонт пошкодженого житла",
              "image" : "https://api2.diia.gov.ua/diia-images/docPhoto-yalta.png",
              "action" : {
                "type" : "news",
                "resource" : "test-id-13"
              }
            }
          },
          {
            "iconCardMlc" : {
              "label" : "Всі новини",
              "iconLeft" : "stack",
              "action" : {
                "type" : "allNews"
              }
            }
          }
        ],
        "dotNavigationAtm" : {
          "count" : 11
        }
      }
    },
    {
      "sectionTitleAtm" : {
        "label" : "Популярні послуги"
      }
    },
    {
      "listItemGroupOrg" : {
        "items" : [
          {
            "label" : "Реєстрація пошкодженого майна",
            "action" : {
              "type" : "damagedProperty"
            },
            "iconRight" : {
              "code" : "ellipseArrowRight"
            }
          },
          {
            "label" : "Заміна водійського посвідчення",
            "action" : {
              "type" : "replacementDriverLicense"
            },
            "iconRight" : {
              "code" : "ellipseArrowRight"
            }
          },
          {
            "label" : "Податки ФОП",
            "action" : {
              "type" : "privateEntrepreneur"
            },
            "iconRight" : {
              "code" : "ellipseArrowRight"
            }
          }
        ]
      }
    }
  ]
}
"""
