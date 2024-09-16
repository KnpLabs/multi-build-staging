<?php

namespace App\DataFixtures;

use App\Entity\KNPeer;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $alessandro = new KNPeer('Alessandro', 'Pozzi', 'alexpozzi');
        $manager->persist($alessandro);

        $pierre = new KNPeer('Pierre', 'Plazanet', 'pedrotroller');
        $manager->persist($pierre);

        $brice = new KNPeer('Brice', 'Correia', 'bricecorreia');
        $manager->persist($brice);

        $manager->flush();
    }
}
