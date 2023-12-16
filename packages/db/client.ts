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

const sql = neon(connectionString);

const db = drizzle(sql);

export async function HelloWorld() {
  const [dbRes] = await sql`SELECT NOW()`;

  return dbRes;
}

export default db;
