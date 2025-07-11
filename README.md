# Custom Authentication & Access Control System

A Ruby on Rails application implementing organization-based access control with age-based participation rules and parental consent workflow.

## 📋 Assignment Overview

This application demonstrates:
- **Organization-Based Access Control**: membership verification, role-based permissions, organization-specific participation rules
- **Age-Based Participation Rules**: age verification during registration, parental consent workflow for minors, age-appropriate content filtering

## 🛠 Technical Stack

- **Ruby on Rails**: 8.0.2
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: CanCanCan
- **Frontend**: Bootstrap 5.3 + Font Awesome
- **Email**: ActionMailer with LetterOpener (development)

## 🚀 Setup Instructions

### 1. Prerequisites
```bash
# Ensure you have Ruby 3.1+ and Rails 8.0+
ruby -v
rails -v

# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib
```

### 2. Installation
```bash
# Clone the repository
git clone <repository-url>
cd assignment

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate

# Start the server
rails server
```

### 3. Access the Application
- Open your browser to `http://localhost:3000`
- The application will be running with sample data

## 🧪 Testing Instructions

### Test Case 1: Adult User Registration & Organization Management
1. **Register as Adult User**
   - Navigate to `/users/sign_up`
   - Fill in details with birth date making user 18+ years old
   - Complete registration

2. **Create Organization**
   - Click "Create Organization"
   - Fill in organization details
   - Verify organization is created successfully

3. **Manage Organization**
   - View organization members
   - Check analytics dashboard
   - Test member approval workflow

### Test Case 2: Minor User Registration & Parental Consent
1. **Register as Minor User**
   - Navigate to `/users/sign_up`
   - Fill in details with birth date making user under 18
   - Enter parent email address
   - Complete registration

2. **Check Email System**
   - LetterOpener will automatically open the consent email in browser
   - Verify email contains proper consent form and child information

3. **Parent Consent Process**
   - Click "Approve Consent" in the email
   - Verify consent page displays child information
   - Approve the consent request

4. **Verify Minor Can Join Organizations**
   - Login as the minor user
   - Navigate to organizations list
   - Verify "Parental Consent Approved" status is shown
   - Try joining an organization - should work

### Test Case 3: Minor Without Parental Consent
1. **Register Minor Without Parent Email**
   - Register as minor but leave parent email blank
   - Verify minor cannot join organizations
   - Check appropriate warning messages are displayed

### Test Case 4: Organization Membership Workflow
1. **Join Organization**
   - As approved user, request to join organization
   - Verify request appears in admin's pending requests

2. **Admin Approval**
   - Login as organization admin
   - View pending member requests
   - Approve membership request

3. **Verify Membership**
   - Check member appears in organization members list
   - Verify member can see organization content

### Test Case 5: Age-Based Restrictions
1. **Minor User Restrictions**
   - Login as minor user
   - Try to create organization (should be restricted until consent)
   - Verify age-appropriate messaging

2. **Adult User Permissions**
   - Login as adult user
   - Verify full access to all features
   - Test organization creation and management


## 📊 Test Data

The application includes sample data:
- Adult users (18+ years old)
- Minor users (under 18)
- Sample organizations
- Various membership statuses

## 🔧 Development Notes

### Email Configuration
- Development uses LetterOpener (emails open in browser)
- Production would use SMTP configuration
- All email templates are responsive and professional

### Database Schema
- Users table with age verification fields
- Organizations with admin relationships
- OrganizationMemberships for role-based access
- Parental consent tracking with secure tokens

---
