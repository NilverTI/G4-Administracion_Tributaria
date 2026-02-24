<header class="topbar">

    <div class="topbar-right">
        <button class="notif-btn">
            <i class="fi fi-rr-bell"></i>
            <span class="notif-badge"></span>
        </button>

        <div class="topbar-user">
            <div class="topbar-user-info">
                <h4>${sessionScope.usuario.persona.nombres}</h4>
                <p>${sessionScope.usuario.rol.nombre}</p>
            </div>

            <div class="topbar-avatar">
                ${sessionScope.usuario.persona.nombres.charAt(0)}
            </div>
        </div>
    </div>
</header>
