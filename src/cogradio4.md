# CogRadio v4
ip\<sey34py

e4
yop5pl8kk
67irpl


Get info about joined channel
``
> INFO [hostname]
INFO [hostname]
``

Send a message. If [metadata] isn't provided, replace it with ?.
``
> SEND [hostname] [nickname] [metadata] [message]
SEND robux-device robux ? Robux
``

Return info about joined channel, requires signature. Access: ##Access
``
> INFOBACK [hostname] [metadata] [access] 
INFOBACK robux-device ? chat=-*,+P123456789;op=/c
``

Change the access of the channel, requires signature and `op` permission.
``
> REACCESS [hostname] [metadata] [access]
``

## Access
Permissions are seperated by semicolons, and permissions are formatted as following:
``
> [permission name]=-[description],+[description],/[permission name]
chat=+*,-P1234567
test=/chat,-Nrobux
``
Minus removes a description from the permission, plus adds a permission from the description, and slashes import from an already-existing permission.

### Descriptions
There are 3 description types: \*, P, and N. \* describes everyone, P describes someone with a specific public key, N describes someone with a specific nickname.

## Basic extensions
Metadata format:
``
foo=bar,qux=quz
``

### Signatures
``
> sig=[signature]
``

### Asset attachments
``
> attachtype=[Sound|Image|Mesh],attachid=[id]
``
