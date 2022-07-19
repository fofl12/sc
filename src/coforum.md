# coforum Protocol v1
coforum is a decentralized forum protocol, using DataStoreService to stores threads an posts. coforum uses RSA for signing posts and threads, and JSON for encoding messages.

## Datastore names
The board names should following the format of coforum.[boardname]
Examples:
* coforum.foo.bar
* coforum.main

## Posting threads
Threads should be posted in threads by adding a new key in the board DataStore, with the key being a random UUID generated with HttpService. The content of the key should follow the following example:
```json
{
	"message": {
		"name": "Example Thread",
		"author": "123456789ABCDEF", // the public key of the author
	},
	"signature": "123456789ABCDEF" // a signature of the message
}
```
All threads should create a new Datastore, that should be the name of the board appended by a slash and the random UUID. Examples:
* coforum.foo.bar/1234-5678-9123
These datastores must have the key "0" in them, which is the first post in the thread.

## Posts in threads
Every post in the thread must be a new key in the datastore of the original thread, with the names being random UUIDs generated with HttpService. The content of the key should follow the following example:
```json
{
	"message": {
		"content": "Example post",
		"prevhash": "987654321FEDCAB", // hash of previous post, not required if first message
		"author": "123456789ABCDEF",
	},
	"signature": "123456789ABCDEF"
}
```

### Attachments
Posts may optionally attach assets and files to their posts, by adding the attachments array.
```json
{
	"message": {
		"content": "Example post",
		"prevhash": "987654321FEDCAB",
		"attachments": [
			{
				"type": "image", // sound, mesh and video are also valid asset types
				"data": "123456789" // ID of asset
			},
			{
				"type": "file",
				"data": "base64" // base64 representation of the file data
			}
		],
		"author": "123456789ABCDEF",
	},
	"signature": "123456789ABCDEF"
}
```