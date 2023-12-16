// import { drizzle } from "drizzle-orm/postgres-js";
// import postgres from "postgres";
import { drizzle } from "drizzle-orm/neon-http";
import { neon, neonConfig } from "@neondatabase/serverless";

const connectionString = process.env.DATABASE_URL as string;

if (!connectionString) {
  throw new Error("DATABASE_URL is not set");
}

neonConfig.fetchConnectionCache = true;

// const client = postgres(connectionString, {
//   prepare: false,
// });

const client = neon(connectionString, { isolationLevel: "Serializable" });

const db = drizzle(client);

export default db;
