# Shopping Cart - Flutter MVVM

Aplicação de carrinho de compras desenvolvida em Flutter seguindo a arquitetura MVVM.

## 📋 Requisitos

- Flutter 3.x
- Dart 3.x

## 🚀 Como executar

```bash
# Instalar dependências
flutter pub get

# Executar o app
flutter run
```

## 🏗️ Arquitetura

O projeto segue a arquitetura **MVVM (Model-View-ViewModel)** com separação clara de responsabilidades:

- **Model**: Entidades de domínio (`Product`, `Cart`, `CartItem`)
- **View**: Widgets de UI que renderizam estados
- **ViewModel**: Lógica de apresentação e gerenciamento de estado
- **Data**: Repositories e DTOs para comunicação com API

## 🛠️ Tecnologias

- **Flutter** - Framework UI
- **Provider** - Gerenciamento de estado com ChangeNotifier
- **Dio** - Cliente HTTP
- **FakeStore API** - API de produtos

## ✨ Funcionalidades

- ✅ Listagem de produtos da API
- ✅ Adicionar produtos ao carrinho
- ✅ Incrementar/decrementar quantidade
- ✅ Remover produtos do carrinho
- ✅ Limite de 10 produtos diferentes
- ✅ Cálculo de subtotal e total
- ✅ Finalização de pedido
- ✅ Estados de loading e erro

## 📱 Screenshots

<div align="center">
  <img src="prints/001.png" width="250" alt="Tela de produtos">
  <img src="prints/002.png" width="250" alt="Produtos no carrinho">
  <img src="prints/003.png" width="250" alt="Carrinho cheio">
</div>

<div align="center">
  <img src="prints/004.png" width="250" alt="Limite de produtos">
  <img src="prints/005.png" width="250" alt="Finalizar compra">
  <img src="prints/006.png" width="250" alt="Pedido concluído">
</div>

## 📂 Estrutura de Pastas

```
lib/
├── core/              # Configurações e constantes
├── data/              # Repositories e DTOs
├── domain/            # Models (entidades)
├── viewmodels/        # Lógica de apresentação
├── views/             # Telas e widgets
└── shared/            # Widgets reutilizáveis
```

## 📝 Padrões Aplicados

- **MVVM** - Separação de responsabilidades
- **Repository Pattern** - Abstração da camada de dados
- **Dependency Injection** - Provider para injeção de dependências
- **Immutability** - Modelos imutáveis
- **SOLID** - Princípios de design
