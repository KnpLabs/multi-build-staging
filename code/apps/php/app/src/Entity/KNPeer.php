<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity()]
class KNPeer
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255, nullable: false)]
    private string $first;

    #[ORM\Column(length: 255, nullable: false)]
    private string $last;

    #[ORM\Column(nullable: false)]
    private string $github;

    public function __construct(string $first, string $last, string $github)
    {
        $this->first = $first;
        $this->last = $last;
        $this->github = $github;
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getFirst(): string
    {
        return $this->first;
    }

    public function getLast(): string
    {
        return $this->last;
    }

    public function getGithub(): string
    {
        return $this->github;
    }
}
