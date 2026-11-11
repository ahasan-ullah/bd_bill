# BD Bill - Bangladesh Electricity Bill Calculator

A modern, accurate, and easy-to-use Flutter application designed to calculate electricity bills in Bangladesh based on official tariff slab structures (e.g., DESCO, DPDC, BPDB, NESCO, BREB, WZPDCL).

## Features

- **Accurate Tariff Calculations**: Supports tiered residential slabs (Lifeline 0-50, 0-75, 76-200, 201-300, 301-400, 401-600, and 600+ units).
- **Customizable Billing Parameters**: Adjust demand charges, meter rent, VAT percentage (default 5%), and rebate rates.
- **Sanctioned Load Adjustment**: Easily configure connected load in kW.
- **Detailed Bill Breakdown**: Itemized view showing energy charge for each slab, VAT, demand charge, and net payable amount.
- **Rates Management**: Browse, customize, or add new tariff slabs.
- **PDF Invoice Generation**: Generate, preview, and share official-style PDF invoice breakdown.
- **Bilingual & Localized**: Supports Bengali currency formatting and typography.
- **Modern UI**: Clean Material Design 3 interface with responsive layout.

## Tech Stack

- **Flutter**: Cross-platform UI toolkit.
- **State Management**: Flutter Riverpod.
- **PDF Export**: pdf & printing packages.
- **Localization**: intl package with Noto Sans Bengali font.

## Getting Started

1. Clone the repository:
   `ash
   git clone https://github.com/ahasan-ullah/bd_bill.git
   cd bd_bill
   `

2. Install dependencies:
   `ash
   flutter pub get
   `

3. Run the application:
   `ash
   flutter run
   `

## License

This project is licensed under the MIT License.
