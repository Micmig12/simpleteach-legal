# EcoScan — App de Reciclagem para iPad

App nativo para iPadOS que usa a câmera para identificar e rastrear seu lixo reciclável.

## Funcionalidades

- **Escaneie seu lixo** — Fotografe qualquer item e a IA identifica automaticamente o material
- **Dashboard com estatísticas** — Veja quantos kg de recicláveis você gerou, sua taxa de reciclagem e sequência de dias
- **Galeria filtrada** — Histórico de todos os itens com filtros por categoria
- **Interface Liquid Glass** — Design premium com efeito de vidro fosco e gradientes escuros

## Categorias Identificadas

| Categoria | Lixeira | Reciclável |
|-----------|---------|------------|
| Papel | Azul | ✅ |
| Plástico | Vermelho | ✅ |
| Vidro | Verde | ✅ |
| Metal | Amarelo | ✅ |
| Eletrônico | Coleta Especial | ✅ |
| Orgânico | Marrom | ❌ |
| Rejeito | Cinza | ❌ |

## Como abrir no Xcode

1. Abra o **Xcode 16+**
2. Crie um novo projeto: **File → New → Project → App (iOS)**
   - Product Name: `EcoScan`
   - Interface: `SwiftUI`
   - Storage: `SwiftData`
   - Minimum Deployments: `iOS 18.0`
3. Copie todos os arquivos da pasta `Sources/EcoScan/` para o projeto
4. Em **Target → Info**, adicione as permissões de câmera e galeria (já no `Info.plist`)
5. Selecione o simulador de iPad ou seu dispositivo
6. Pressione **⌘ R** para rodar

## Tecnologias

- **Swift 6** + **SwiftUI**
- **SwiftData** — persistência local
- **Vision Framework** — classificação de imagens com Core ML
- **AVFoundation** — câmera ao vivo
- **PhotosUI** — acesso à galeria
- **Charts** — gráfico de rosca por categoria

## Estrutura de Arquivos

```
EcoScan/
├── EcoScanApp.swift           # Entry point
├── Models/
│   ├── TrashItem.swift        # SwiftData model
│   ├── RecyclingCategory.swift
│   └── RecyclingStats.swift
├── Views/
│   ├── Main/ContentView.swift     # NavigationSplitView (iPad) / TabView (iPhone)
│   ├── Dashboard/DashboardView.swift
│   ├── Camera/ScanView.swift
│   ├── Analysis/AnalysisView.swift
│   ├── History/HistoryView.swift
│   └── Components/
│       ├── LiquidGlassCard.swift
│       ├── CategoryBadge.swift
│       └── DonutChartView.swift
├── Services/
│   └── TrashClassifier.swift   # Vision framework
└── Resources/
    └── Info.plist
```
