defmodule Test.DB do
  def setup do
    clean_up()
    setup_table()
    setup_trigger()
  end

  def clean_up() do
    Ecto.Adapters.SQL.query!(
      Test.Repo,
      """
      DROP TABLE public.users;
      """
    )
  end

  def setup_table do
    Ecto.Adapters.SQL.query!(
      Test.Repo,
      """
      CREATE TABLE public.users (
        id bigserial NOT NULL,
        email varchar(255) NULL,
        pass varchar(255) NULL
      );
      """
    )
  end

  def setup_trigger do
    Ecto.Adapters.SQL.query!(
      Test.Repo,
      """
      CREATE OR REPLACE FUNCTION notify_changes()
      RETURNS trigger AS $$
      BEGIN
        PERFORM pg_notify(
          'evt_test',
          json_build_object(
            'operation', TG_OP,
            'table', TG_TABLE_NAME::regclass::text,
            'record', row_to_json(NEW)
          )::text
        );

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
      """
    )

    Ecto.Adapters.SQL.query!(
      Test.Repo,
      """
      CREATE TRIGGER table_changed
      AFTER INSERT OR UPDATE
      ON users
      FOR EACH ROW
      EXECUTE PROCEDURE notify_changes();
      """
    )
  end

  def insert_user() do
    Ecto.Adapters.SQL.query!(
      Test.Repo,
      """
      insert into users (email, pass) values ('demo', 'demo00');
      """
    )
  end
end
