# Flutter CafeBazaarAuth

Using this library, you can always access your users without having to implement a local login. Firstly, this reduces uncertainty, lack of security, and bot users due to its unified login solution. It also reduces the cost of user authentication by email or text messages. Furthermore, you do not lose the user history and data in your app if they uninstall or change their device.

In the first step, Bazaar gives you a unique user id for each user/app which remains the same forever. More information about the user such as username, email, etc. will be supported in future releases after adding the user permission feature.

To start working with `CafeBazaarAuth`, you'll need to add its this package to your `pubspec.yaml` file:

```
cafebazaar_auth: ^1.0.2
```

Then import it :

``` dart
import 'package:cafebazaar_auth/cafebazaar_auth.dart';
```

## In-app login

To authenticate user, you'll need to use `signIn` function:

``` dart
BazaarAccount? account = await CafeBazaarAuth.signIn();

print(account.id);
```

At the moment, you can only retrieve the default information which includes `accountID`. More features will be added soon.

In case the user has granted the login access, the returned `account` is not null and you can read data from the `account` model.


In case the user has already granted the access, use the following getter to get the latest data:

``` dart
BazaarAccount? account = await CafeBazaarAuth.lastSignedInAccount;
```

In case the user has not granted the login access, the `account` value is null.


To display Bazaar login button in your application, you can use the following Widget:

``` dart
CafeBazaarLoginButton(
    text: "Login With Bazaar",                      // Optional
    textStyle: TextStyle(color: Colors.white),      // Optional
    iconSize: 28,                                   // Optional, Default: 36
    onPressed: signIn,                              // Required
)
```

You can also design and use your own widget.

## In-app storage

To save the user data, you'll need to call the following method:

``` dart
String? savedData = await CafeBazaarAuth.saveData("My String Data");
```

You can get access to saved data by the following getter:

``` dart
String? savedData = await CafeBazaarAuth.savedData;
```

# Security notes

In order to prevent phishing and information theft, use the following getter to ensure that the correct version of Bazaar is available on the user device:

``` dart
bool? isBazaarInstalled = CafeBazaarAuth.isBazaarInstalledOnDevice;
```

# Bazaar in client device

To ensure that the Bazaar app version on the user device supports Bazaar login and in-app storage, use the following getter:

``` dart
CafeBazaarUpdateInfo? updateInfo = CafeBazaarAuth.isNeededToUpdateBazaar;

print(updateInfo.needToUpdateForAuth);
print(updateInfo.needToUpdateForStorage);
```

If the Bazaar app is not installed, you can use following method:

``` dart
CafeBazaarAuth.showInstallBazaarView();
```

In case an update for the Bazaar app is required, use the following method:

``` dart
CafeBazaarAuth.showUpdateBazaarView();
```