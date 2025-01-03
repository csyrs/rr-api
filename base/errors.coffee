# These classes wrap API and client code errors so that they can be easily classified and handled.
#
# Various properties that may appear on errors:
#
# - cause: an Error object that is responsible for triggering the current error
# - description: a text string describing the error (human-readable)
# - reason: a text string describing the error (machine-readable)

import { Time } from 'rr-lib'

class Base extends Error
	constructor: (message) ->
		super(message)
		@.name = @.constructor.name
class Unknown extends Base
	constructor: ({ cause, description, reason }) ->
		if description or reason
			super([reason, description].join(' / '))
			@.description = description
			@.reason = reason
		else if cause
			super(cause.message)
		else
			super('An unknown error occurred.')

class DataLocationChanged extends Base
	constructor: ({ code, description, reason }) ->
		super("HTTP #{code} / #{reason or '?'}")
		@.code = code
		@.description = description
		@.reason = reason
class DataNotAvailable extends Base
	constructor: ({ code, description, reason }) ->
		super("HTTP #{code} / #{reason or '?'}")
		@.code = code
		@.description = description
		@.reason = reason
class InteractionRejected extends Base
	constructor: ({ code, description }) ->
		super("#{code}: #{description}")
		@.code = code
		@.description = description
class LoginFailure extends Base
	constructor: ({ reason }) ->
		super('reason code "' + reason + '"')
		@.reason = reason
class MalformedID extends Base
	constructor: ({ id }) ->
		super('"' + id + '"')
		@.id = id
class NeedCredentials extends Base
	constructor: ({ description }) ->
		super(description)
		@.description = description
class NetworkFailure extends Base
	constructor: ({ cause }) ->
		super(cause.message)
class NotLoggedIn extends Base
	constructor: ->
		super('need to login to perform that action')
class OverRatelimit extends Base
	constructor: ({ waitMs }) ->
		super("wait #{Time.msToS(waitMs, { trunc: true })} seconds")
		@.waitMs = waitMs
class ServerFailure extends Base
	constructor: ({ code, description, reason }) ->
		super("HTTP #{code} / #{reason or '?'}")
		@.code = code
		@.description = description
		@.reason = reason

export default {

	Base
	Unknown

	DataLocationChanged
	DataNotAvailable
	InteractionRejected
	LoginFailure
	MalformedID
	NeedCredentials
	NetworkFailure
	NotLoggedIn
	OverRatelimit
	ServerFailure

}