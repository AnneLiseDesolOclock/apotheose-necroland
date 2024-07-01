BEGIN;

SET CLIENT_ENCODING TO 'UTF-8';

DROP TABLE IF EXISTS "role" CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS "status" CASCADE;
DROP TABLE IF EXISTS "reservation";
DROP TABLE IF EXISTS "category" CASCADE;
DROP TABLE IF EXISTS "attraction" CASCADE;
DROP TABLE IF EXISTS "tag" CASCADE;
DROP TABLE IF EXISTS "photo";
DROP TABLE IF EXISTS "message";
DROP TABLE IF EXISTS "price";
DROP TABLE IF EXISTS "attraction_has_tag";

CREATE TABLE "role" (
	"id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"name" TEXT UNIQUE NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ  
);

CREATE TABLE "user" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    "firstname" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "address" TEXT NOT NULL, 
    "postal_code" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "email" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
    "role_id" INTEGER REFERENCES "role"("id") NOT NULL DEFAULT 1
);

CREATE TABLE "status" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "label" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ
);

CREATE TABLE "reservation" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "start_date" DATE NOT NULL, 
    "end_date" DATE NOT NULL,
    "nb_people" INTEGER NOT NULL,
    "hotel" TEXT NOT NULL,
    "total_price" DECIMAL(10, 2) NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
    "user_id" INTEGER REFERENCES "user"("id") NOT NULL,
    "status_id" INTEGER REFERENCES "status"("id") NOT NULL DEFAULT 1,
    CONSTRAINT "duration" CHECK (EXTRACT(DAY FROM AGE("end_date", "start_date")) <= 3)
);

CREATE TABLE "category" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    "name" TEXT UNIQUE NOT NULL,
    "slug" TEXT UNIQUE NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ
);

CREATE TABLE "attraction" (
	"id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"name" TEXT NOT NULL,
	"description" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
	"category_id" INTEGER REFERENCES "category"("id") NOT NULL
);

CREATE TABLE "tag" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    "name" TEXT UNIQUE NOT NULL,
    "slug" TEXT UNIQUE NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ
);

CREATE TABLE "photo" (
	"id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	"name" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
	"attraction_id" INTEGER REFERENCES "attraction"("id") NOT NULL
);

CREATE TABLE "message" (
	"id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	"object" TEXT NOT NULL,
	"content" TEXT NOT NULL,
	"email" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
	"firstname" TEXT NOT NULL,
	"createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
    "status_id" INTEGER REFERENCES "status"("id") NOT NULL DEFAULT 3
);

CREATE TABLE "price" (
	"id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	"duration" INTEGER NOT NULL,
	"price" DECIMAL(10,2) NOT NULL,
	"hotel" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ
);

CREATE TABLE "attraction_has_tag" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMPTZ,
    "attraction_id" INTEGER REFERENCES "attraction"("id"),
    "tag_id" INTEGER REFERENCES "tag"("id")
);

COMMIT;