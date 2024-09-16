<?php

namespace App\Controller;

use App\Entity\KNPeer;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HomepageController extends AbstractController
{
    public function __construct(private readonly EntityManagerInterface $entityManager)
    {}

    #[Route('/', name: 'homepage')]
    public function index(): Response
    {
        $users = $this->entityManager->getRepository(KNPeer::class)->findAll();

        return $this->render('pages/homepage.html.twig', [
            'users' => $users,
        ]);
    }
}
