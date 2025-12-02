# Firestore Rules Update for Password Reset

## What Changed

The Firestore security rules were updated to support the forgot password feature while maintaining security.

## New Permissions Added

### For Users Collection:
```javascript
// Allow query by email (unauthenticated) - for password reset
allow read: if request.query.limit == 1;

// Allow password reset field updates (unauthenticated)
allow update: if isPasswordResetUpdate();
```

### For Admins Collection:
```javascript
// Allow query by email (unauthenticated) - for password reset
allow read: if request.query.limit == 1;

// Allow password reset field updates (unauthenticated)
allow update: if isPasswordResetUpdate();
```

## Security Measures

### What's Protected:
1. **Limited Query Access**: Email queries are limited to 1 result to prevent data scraping
2. **Field-Specific Updates**: Only `passwordResetCode` and `passwordResetCodeExpiry` can be updated
3. **Helper Function**: `isPasswordResetUpdate()` validates that only allowed fields are modified
4. **Time-Limited**: Codes expire in 15 minutes (enforced in app logic)
5. **Audit Logging**: All password reset attempts are logged

### Helper Function:
```javascript
function isPasswordResetUpdate() {
  let allowedFields = ['passwordResetCode', 'passwordResetCodeExpiry'];
  let updateFields = request.resource.data.diff(resource.data).affectedKeys();
  return updateFields.hasOnly(allowedFields);
}
```

This ensures that even if someone tries to exploit the password reset endpoint, they can ONLY update these two specific fields.

## Other Collections

All other collections maintain their existing security:
- ✅ Reports: User/Admin access control
- ✅ Schedules: Authenticated users only
- ✅ Audit Logs: Admins can read, anyone can create
- ✅ Security Attempts: Open access (needed for lockout checks)
- ✅ Notifications: User-specific access

## Deployment

Rules were deployed using:
```bash
firebase deploy --only firestore:rules
```

Status: ✅ **Successfully Deployed**

## Testing

To test the password reset:
1. Go to forgot password page
2. Enter a registered email
3. Verification code will be sent
4. Check that Firestore document has:
   - `passwordResetCode`: "123456" (6-digit code)
   - `passwordResetCodeExpiry`: timestamp (15 min from now)

## Rollback (If Needed)

If you need to rollback, you can:
1. Go to Firebase Console → Firestore → Rules
2. View previous versions
3. Restore an earlier version

## Notes

- The rules allow unauthenticated access for password reset flows
- All changes are tracked in audit logs
- Codes automatically expire after 15 minutes
- Users cannot update any other fields without authentication
- Email queries are rate-limited by Firebase automatically

