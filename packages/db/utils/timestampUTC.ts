import {
  ColumnBaseConfig,
  ColumnBuilderBaseConfig,
  MakeColumnConfig,
} from "drizzle-orm";
import {
  AnyPgTable,
  PgTimestampBuilder as DefaultBuilder,
  PgTimestamp as DefaultPgTimestamp,
  PgTimestampBuilderInitial,
  PgTimestampConfig,
  PgTimestampStringBuilder,
} from "drizzle-orm/pg-core";

export class PgTimestampBuilder<
  T extends ColumnBuilderBaseConfig
> extends DefaultBuilder<T> {
  constructor(name: T["name"], config: PgTimestampConfig | undefined) {
    super(name, config?.withTimezone || false, config?.precision);
  }

  build<TTableName extends string>(
    table: AnyPgTable<{ name: TTableName }>
  ): PgTimestamp<MakeColumnConfig<T, TTableName>> {
    return new PgTimestamp<MakeColumnConfig<T, TTableName>>(table, this.config);
  }
}

export class PgTimestamp<
  T extends ColumnBaseConfig
> extends DefaultPgTimestamp<T> {
  override mapFromDriverValue: (value: string) => Date = (value: string) => {
    return new Date(value + " UTC");
  };

  override mapToDriverValue: (value: Date) => string = (value: Date) => {
    return value.toISOString();
  };
}

export function timestamp<TName extends string>(
  name: TName,
  config?: PgTimestampConfig<"date">
): PgTimestampBuilderInitial<TName>;
export function timestamp(name: string, config: PgTimestampConfig = {}) {
  if (config.mode === "string") {
    return new PgTimestampStringBuilder(
      name,
      config?.withTimezone || false,
      config?.precision
    );
  }
  return new PgTimestampBuilder(name, config);
}
