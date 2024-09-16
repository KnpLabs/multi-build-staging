<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20240916131040 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Add KNPeer entity';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE knpeer (id INT AUTO_INCREMENT NOT NULL, first VARCHAR(255) NOT NULL, last VARCHAR(255) NOT NULL, github VARCHAR(255) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE `utf8_unicode_ci` ENGINE = InnoDB');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('DROP TABLE knpeer');
    }
}
