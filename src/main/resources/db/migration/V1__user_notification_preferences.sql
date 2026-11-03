CREATE TABLE IF NOT EXISTS tb_user_notification_preferences (
    user_id INTEGER PRIMARY KEY REFERENCES tb_user(id) ON DELETE CASCADE,
    reports BOOLEAN NOT NULL DEFAULT FALSE,
    news BOOLEAN NOT NULL DEFAULT FALSE,
    events BOOLEAN NOT NULL DEFAULT FALSE
);
-- Documentação: cria ou atualiza a estrutura persistente descrita nesta migração.
