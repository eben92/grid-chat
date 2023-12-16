DO $$ BEGIN
 CREATE TYPE "type" AS ENUM('image', 'video', 'raw');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Account" (
	"id" varchar(32) PRIMARY KEY NOT NULL,
	"userId" varchar(32) NOT NULL,
	"type" varchar(191) NOT NULL,
	"provider" varchar(191) NOT NULL,
	"providerAccountId" varchar(191) NOT NULL,
	"refresh_token" text,
	"access_token" text,
	"expires_at" integer,
	"token_type" varchar(30),
	"scope" varchar(191),
	"id_token" text,
	"session_state" varchar(191)
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Attachment" (
	"id" varchar(32) PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"url" varchar(255) NOT NULL,
	"type" "type" NOT NULL,
	"bytes" integer NOT NULL,
	"width" integer,
	"height" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "DirectMessageInfo" (
	"channel_id" varchar(32) NOT NULL,
	"user_id" varchar(191) NOT NULL,
	"to_user_id" varchar(191) NOT NULL,
	"open" boolean DEFAULT true,
	CONSTRAINT DirectMessageInfo_user_id_to_user_id PRIMARY KEY("user_id","to_user_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "GroupInvite" (
	"group_id" integer NOT NULL,
	"code" varchar(191) PRIMARY KEY NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Group" (
	"serial" serial PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"unique_name" varchar(32) NOT NULL,
	"icon_hash" integer,
	"channel_id" varchar(32) DEFAULT '' NOT NULL,
	"owner_id" varchar(191) NOT NULL,
	"public" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Member" (
	"group_id" integer NOT NULL,
	"user_id" varchar(191) NOT NULL,
	CONSTRAINT Member_group_id_user_id PRIMARY KEY("group_id","user_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "MessageChannel" (
	"id" varchar(32) PRIMARY KEY NOT NULL,
	"last_message_id" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Message" (
	"serial" serial PRIMARY KEY NOT NULL,
	"author_id" varchar(191) NOT NULL,
	"channel_id" varchar(32) NOT NULL,
	"content" varchar(2000) NOT NULL,
	"timestamp2" timestamp DEFAULT now() NOT NULL,
	"attachment_id" varchar(32),
	"embeds" json,
	"reply_id" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Session" (
	"id" varchar(191) PRIMARY KEY NOT NULL,
	"sessionToken" varchar(191) NOT NULL,
	"userId" varchar(191) NOT NULL,
	"expires" timestamp (3) NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "User" (
	"id" varchar(191) PRIMARY KEY NOT NULL,
	"name" varchar(191) DEFAULT 'User' NOT NULL,
	"email" varchar(191),
	"emailVerified" timestamp (3),
	"image" varchar(191),
	"is_ai" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Account_provider_providerAccountId_key" ON "Account" ("provider","providerAccountId");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Account_userId_idx" ON "Account" ("userId");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "GroupInvite_group_id_idx" ON "GroupInvite" ("group_id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Group_unique_name_key" ON "Group" ("unique_name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Group_channel_idx" ON "Group" ("channel_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Member_group_id_idx" ON "Member" ("group_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Member_user_id_idx" ON "Member" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Message_channel_id_idx" ON "Message" ("channel_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Message_timestamp_idx" ON "Message" ("timestamp2");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Session_sessionToken_key" ON "Session" ("sessionToken");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Session_userId_idx" ON "Session" ("userId");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "User_email_key" ON "User" ("email");