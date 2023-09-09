

select  concat (rtrim (so.NombreSocio),' ', rtrim (so.ApellidoSocio)) Nombre 
  , ct.NombreClasificacion
  , (select convert(date, FechaEnJudicial) from Cooperativa.dbo.GastosCredito as g where cr.NumeroCredito= g.NumeroCredito and convert (date,FechaEnJudicial) != convert(date,'1900-01-01')) FechaEnJudicial
  , so.NumeroSocio 
  , so.NumeroDocumento
  , cr.NumeroCredito
  ,(select sl.Saldo 
             from cooperativa.dbo.SaldosCreditoNuevo as sl 
			 where sl.NumeroCredito = cr.NumeroCredito) as saldo
  , cr.MontoOtorgadoCredito
   , cr.FechaDesembolso
  , (select min(Vencimiento) from Cooperativa.dbo.vCuotasPendientes as p where cr.NumeroCredito = p.NumeroCredito) ProximoVencimientocuota
  , (select FechaPagoCuotaCredito from Cooperativa.dbo.SaldosCredito as s where cr.NumeroCredito = s.NumeroCredito) UltimoPago
  ,(select max(NumeroCuotaCredito) cuota
             from Cooperativa.dbo.PagosCredito as p
			 where p.NumeroCredito= cr.NumeroCredito) as pagoCredito
  , cr.PlazoOtorgadoCredito
--, sa.saldo      ---se podria hacer de esta forma tambien
  , DATEDIFF(YEAR,so.FechaNacimientoSocio,GETDATE()) as Edad
  ,(select min(SaldoCredito) from Cooperativa.dbo.CreditosCalificacion ca where ca.NumeroCredito= cr.NumeroCredito  and convert (date,VencimientoCuota) <='2022-09-30') SaldoHastaAgosto2022

  
from 
    Cooperativa.dbo.CreditosReferenciales as cr
    inner join Cooperativa.dbo.Socios as so on so.NumeroSocio= cr.NumeroSocio
  --inner join Cooperativa.dbo.SaldosCreditoNuevo as sa on cr.NumeroCredito = sa.NumeroCredito  --se podria hacer de esta forma tambien
 	inner join Cooperativa.dbo.OficialCredito occ on occ.CodigoOficialCredito = cr.CodigoOficial  -- compare con oficial de creditos para saber nombre de clasificacion
	left join Cooperativa.dbo.ClasificacionTipoCredito ct on ct.CodigoClasificacion = occ.CodigoClasificacion


where cr.EstadoCredito= 1 and cr.MontoOtorgadoCredito >= 90000000 and convert (date,fechaDesembolso) <= convert (date,'2021-07-31')
and so.NumeroSocio in (63343
, 113908
, 24705
, 42369
, 66380
, 7836
, 13649
, 164
, 26576
, 22257
, 825
, 76212
, 111009
, 24038
, 74462
, 85278
, 11111
, 7854
, 19252
, 973
, 973
, 129833
, 133854
, 68240
, 68240
, 2038
, 71000
, 23954
, 17674
, 5775
, 5775
, 5775
, 36201
, 21402
, 16633
, 126516
, 47465
, 70397
, 7419
, 44512
, 15738
, 44299
, 19410
, 90438
, 90438
, 8018
, 40439
, 59406
, 128854
, 2644
, 31299
, 3878
, 35123
, 18634
, 69648
, 43022
, 22466
, 42770
, 86700
, 86700
, 112282
, 62288
, 102337
, 102337
, 102337
, 77845
, 46166
, 8745
, 1907
, 1907
, 9502
, 125581
, 128913
, 16877
, 12
, 12
, 65491
, 25517
, 26669
, 7157
, 10930
, 49073
, 36834
, 31417
, 74275
, 25595
, 1057
, 78850
, 128431
, 64000
, 114879
, 1780
, 7899
, 7752
, 59942
, 51721
, 130644
, 6998
, 42337
, 135186
, 7419
, 85278
, 8143
, 10293
, 122419
, 2498
, 8457)

order by NumeroSocio asc
  