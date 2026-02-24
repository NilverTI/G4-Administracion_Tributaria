package com.tributaria.service;

import com.tributaria.dao.PagoDAO;
import com.tributaria.entity.Pago;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public class PagoService {

    private final PagoDAO pagoDAO = new PagoDAO();
    private final CuotaService cuotaService = new CuotaService();

    public void registrar(Pago pago) {

        if (pago == null || pago.getCuota() == null || pago.getCuota().getId() == null) {
            throw new IllegalArgumentException("Pago o cuota inválida.");
        }
        if (pago.getMonto() == null) {
            throw new IllegalArgumentException("Monto inválido.");
        }
        if (pago.getMedioPago() == null || pago.getMedioPago().isBlank()) {
            throw new IllegalArgumentException("Medio de pago requerido.");
        }

        // Código tipo REC-2026-AB12
        pago.setCodigo("REC-" + LocalDate.now().getYear() + "-"
                + UUID.randomUUID().toString().substring(0, 4).toUpperCase());

        // 1) Guardar recibo/pago
        pagoDAO.guardar(pago);

        // 2) Marcar cuota pagada (por ID de cuota)
        cuotaService.marcarComoPagada(pago.getCuota().getId());
    }

    public List<Pago> listar() {
        return pagoDAO.listar();
    }
}