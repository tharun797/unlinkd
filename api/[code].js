import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://qoaxsrfzvfsobwnmphhe.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFvYXhzcmZ6dmZzb2J3bm1waGhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMzM5MTMsImV4cCI6MjA5NTgwOTkxM30.OqcFlBEZ1zM5_gg0VNQD-MAY9VOzt5yd1EXEhcSZ2JY' // your legacy anon key
);

export default async function handler(req, res) {
  const { code } = req.query;

  const { data, error } = await supabase
    .from('links')
    .select('original_url')
    .eq('code', code)
    .maybeSingle();

  if (error || !data) {
    return res.status(404).send('Link not found');
  }

  res.redirect(301, data.original_url);
}