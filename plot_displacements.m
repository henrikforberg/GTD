function plot_displacements(N, E, U, scale)
    N(:, 1:2) = N(:, 1:2) + 1500;
    F = gen_F(N, [0, 0, -1.5]);
    B = gen_B(N);
    New_Q = update_mesh(U, N);
    plot_mesh(N, E, 'col', [0 0 0], 'tekst', 1, 'Clf', 1);
    plot_mesh(New_Q, E, 'col', [0.8 0 0], 'tekst', 1, 'Clf', 0);
    plot_F(N, F, scale);
    plot_B(N, B, scale);
end