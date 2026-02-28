import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Apero Sexy - Planches Apéro Osées',
  description: 'Planches apéritif originales pour EVG/EVJF. Fabriquées en France avec humour.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  );
}
