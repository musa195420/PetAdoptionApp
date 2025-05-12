
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/16f9fbbc-d593-4aba-afcb-bba49e149fa7" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/092a728b-20c8-4c35-b4d4-400bf9fbe3a5" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/bfcd18c4-e9bc-4bfe-8dc4-952d19c223c9" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/c129765f-6835-4251-be43-112f5fb8343e" width="180"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/5bee79c9-d6ba-4fbf-8a18-796546d1d67f" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/8944a96d-9bfa-4493-a6bb-3e3177eb67d6" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/b9037e88-7725-4f25-91fe-a2a93b1193bf" width="180"/></td>
    <td><img src="https://github.com/user-attachments/assets/9d615b17-40d5-449c-bc93-180b4de5ee59" width="180"/></td>
  </tr>
</table>

# 🐾 PetAdopt – Flutter Pet Adoption App


**PetAdopt** is a cross-platform pet adoption app built with **Flutter**, supporting adopters and donors to connect over secure, verified pet listings. It features role-based access (Adopter, Donor, Admin), real-time chat, adoption tracking, health history, ML-based species detection, and secure meetup processes.

---

## 📱 App Features

### ◎ General Functionality
- ⦿ View nearby pets based on location
- ⦿ Filter pets by species, breed, age, and city
- ⦿ Mark pets as favourites
- ⦿ Secure chat system using Firebase Firestore
- ⦿ Location sharing and scheduling secure meetups
- ⦿ Track pet adoption and health history
- ⦿ ML model (PyTorch Light) to auto-detect pet species (Dog, Cat, Bird)

---

## 👤 User Roles & Flows

### ◉ Adopter (Pet Seeker)
- ⦿ Browse pets and filter by preference
- ⦿ Add to favourites (with login/signup if not authenticated)
- ⦿ View pet details and message the donor
- ⦿ Request meetups and complete secure adoptions
- ⦿ Leave feedback post-adoption

### ◉ Donor (Pet Owner)
- ⦿ Register and list pets with health details
- ⦿ Upload pet images and medical info
- ⦿ Submit for admin verification
- ⦿ Manage listed pets (edit, delete, resubmit if rejected)
- ⦿ Chat with adopters and confirm secure meetups

### ◉ Admin (System Operator)
- ⦿ Approve/reject submitted pet listings
- ⦿ Configure species, breeds, vaccinations, diseases
- ⦿ Manage users and deactivate inappropriate listings
- ⦿ Monitor meetups and secure hand-offs

---

## 📸 ML-Powered Pet Detection
- ✅ Built with PyTorch Light
- ✅ Automatically classifies pets as Dog, Cat, or Bird based on uploaded images
- ✅ Helps streamline user experience and accuracy in pet listings

---

## 🗂️ Directory Overview
musa195420-petadoptionapp/
├── lib/
│ ├── models/ # Data models: requests, responses, Hive entities
│ ├── services/ # API, DB, network, logging, pref
│ ├── viewModel/ # MVVM logic per screen/module
│ ├── views/ # Screens for adopter, donor, admin, modals
│ ├── custom_widgets/ # Custom UI components
│ ├── helpers/ # Constants, location, provider, lifecycle
│ └── main.dart
├── assets/ # JSON, SVGs, carousel images, language files
├── test/ # Unit tests
├── android/ ios/ linux/ macos/ windows/ web/ # Platform-specific configs


---

## 🧪 Data Entities Summary

| Table             | Description |
|------------------|-------------|
| Users            | All user accounts (admin/donor/adopter) |
| Pets             | Pet profile with species, breed, and approval status |
| PetHealthInfo    | Links pets with diseases, vaccines, disabilities |
| Favorites        | Stores adopter-pet favourites |
| Messages         | Chat data between users |
| MeetupCards      | Scheduled meetings with pet and user info |
| SecureMeetups    | Legal form entries during final adoption hand-off |
| Admin Configs    | Species, Breed, Diseases, Medications, Locations |

---

## 💬 Functional Highlights

- 🐶 Auto-suggest pets by geolocation
- 🧬 Health info filters based on species
- 🗺️ Live location coordination during meetup
- 📝 Secure form with adopter ID, proof photo
- 📸 ML model to identify species in real-time
- 🌐 Multilingual JSON support (EN/FR)
- 🔐 Role-based screen access

---

## 🧠 ML Model Integration (Pet Species Identification)

- Model: PyTorch Light
- Inputs: Pet image uploads
- Outputs: Species prediction (Dog / Cat / Bird)
- Pipeline:
  - Data collection → Preprocessing → Model Training → Integration → Testing

---

## 🚀 Getting Started

1. Clone the repo:
```bash
git clone https://github.com/musa195420/PetAdoptionApp
cd PetAdoptionApp



