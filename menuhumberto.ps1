do {
    Clear-Host
    Write-Host "===== MENU GERAL =====" 
    Write-Host "1  - Abrir Programa (Numeros Antecessor e Sucessor)"
    Write-Host "2  - Abrir Programa (Rendimento do Aluno)"
    Write-Host "3  - Abrir Processos Customizados"
    Write-Host "4  - Listar Processos Customizados"
    Write-Host "5  - Iniciar o Navegador Edge"
    Write-Host "6  - Finalizar Processos por ID"
    Write-Host "7  - Finalizar Processos por Nome"
    Write-Host "8  - Verificar se um processo esta rodando (Customizado)"
    Write-Host "9  - Listar Servicos do Sistema Operacional Parados"
    Write-Host "10 - Listar os 20 processos que ocupam mais memoria RAM"
    Write-Host "11 - Sair do Script"
    Write-Host "====================="
    $opcao = Read-Host "Escolha uma opcao"

    switch ($opcao) {

        "1" {
            $n = [int](Read-Host "Digite um numero")
            Write-Host "Antecessor: $($n - 1)"
            Write-Host "Numero: $n"
            Write-Host "Sucessor: $($n + 1)"
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "2" {
            $nome = Read-Host "Nome do aluno"
            $n1   = [double](Read-Host "Nota 1")
            $n2   = [double](Read-Host "Nota 2")
            $media = ($n1 + $n2) / 2
            Write-Host "Aluno: $nome | Media: $media"
            if ($media -ge 6)     { Write-Host "Situacao: APROVADO" }
            elseif ($media -ge 5) { Write-Host "Situacao: RECUPERACAO" }
            else                  { Write-Host "Situacao: REPROVADO" }
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "3" {
            $proc = Read-Host "Nome do processo para abrir (ex: notepad, calc, mspaint)"
            Start-Process $proc
            Write-Host "Processo '$proc' iniciado!"
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "4" {
            $nome = Read-Host "Nome do processo para listar (ex: notepad)"
            try {
                $procs = Get-Process -Name $nome
                $procs | Format-Table Name, Id, @{L="Memoria(MB)";E={[math]::Round($_.WorkingSet64/1MB,2)}} -AutoSize
            } catch {
                Write-Host "Nenhum processo '$nome' encontrado."
            }
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "5" {
            $url = Read-Host "URL para abrir (deixe em branco para pagina inicial)"
            if ($url) { Start-Process "msedge" $url } else { Start-Process "msedge" }
            Write-Host "Edge iniciado!"
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "6" {
            $id = [int](Read-Host "Digite o PID do processo")
            try {
                Stop-Process -Id $id -Force
                Write-Host "Processo $id finalizado!"
            } catch {
                Write-Host "PID $id nao encontrado."
            }
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "7" {
            $nome = Read-Host "Nome do processo para finalizar"
            try {
                Stop-Process -Name $nome -Force
                Write-Host "Processo '$nome' finalizado!"
            } catch {
                Write-Host "Processo '$nome' nao encontrado."
            }
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "8" {
            $nome = Read-Host "Nome do processo para verificar"
            try {
                $p = Get-Process -Name $nome
                Write-Host "Processo '$nome' esta RODANDO."
                $p | Format-Table Name, Id -AutoSize
            } catch {
                Write-Host "Processo '$nome' NAO esta rodando."
            }
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "9" {
            Get-Service | Where-Object { $_.Status -eq "Stopped" } | Format-Table DisplayName, Status -AutoSize
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "10" {
            Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 20 |
                Format-Table Name, Id, @{L="Memoria(MB)";E={[math]::Round($_.WorkingSet64/1MB,2)}} -AutoSize
            Read-Host "Pressione Enter para voltar ao menu"
        }

        "11" {
            Write-Host "Saindo do script, aperte F5 pra rodar novamente"
        }

        default {
            Write-Host "Opcao invalida!"
            Start-Sleep -Seconds 1
        }
    }

} while ($opcao -ne "11")
