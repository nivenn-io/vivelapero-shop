import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Vive l\'Apéro - Planches Apéro Artisanales',
  description: 'Planches apéritif artisanales fabriquées en France. Designs originaux et personnalisation laser.',
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
