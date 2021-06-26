SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+07:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


DELIMITER $$
DROP PROCEDURE IF EXISTS `insert_hasil_test`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_hasil_test` (IN `pid_sesi` VARCHAR(255), IN `pid_peserta` VARCHAR(255), IN `pnilai` INT)  IF EXISTS (SELECT * FROM hasil_test WHERE id_sesi = pid_sesi AND id_peserta = pid_peserta) THEN
	UPDATE hasil_test SET nilai = pnilai WHERE id_sesi = pid_sesi AND id_peserta = pid_peserta;
ELSE
	INSERT INTO hasil_test (id_peserta, id_sesi, nilai) VALUES (pid_peserta, pid_sesi, pnilai);
END IF$$

DELIMITER ;

DROP TABLE IF EXISTS `hasil_test`;
CREATE TABLE IF NOT EXISTS `hasil_test` (
  `id_peserta` varchar(255) NOT NULL,
  `id_sesi` varchar(255) NOT NULL,
  `nilai` int(11) NOT NULL,
  KEY `id_peserta` (`id_peserta`),
  KEY `id_sesi` (`id_sesi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `peserta`;
CREATE TABLE IF NOT EXISTS `peserta` (
  `id_peserta` varchar(255) NOT NULL,
  `nama_peserta` varchar(255) NOT NULL,
  PRIMARY KEY (`id_peserta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DROP TRIGGER IF EXISTS `hapus_hasil_test1`;
DELIMITER $$
CREATE TRIGGER `hapus_hasil_test1` BEFORE DELETE ON `peserta` FOR EACH ROW DELETE FROM hasil_test WHERE id_peserta = OLD.id_peserta
$$
DELIMITER ;

DROP TABLE IF EXISTS `sesi_test`;
CREATE TABLE IF NOT EXISTS `sesi_test` (
  `id_sesi` varchar(255) NOT NULL,
  `nama_sesi` varchar(255) NOT NULL,
  `tanggal_sesi` date NOT NULL,
  `waktu_sesi` time NOT NULL,
  PRIMARY KEY (`id_sesi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sesi_test` (`id_sesi`, `nama_sesi`, `tanggal_sesi`, `waktu_sesi`) VALUES
('PSI01', 'Psikotes 1', '2021-06-26', '09:00:00'),
('W001', 'Wawancara Personal', '2021-06-28', '09:00:00');
DROP TRIGGER IF EXISTS `hapus_hasil_test2`;
DELIMITER $$
CREATE TRIGGER `hapus_hasil_test2` BEFORE DELETE ON `sesi_test` FOR EACH ROW DELETE FROM hasil_test WHERE id_sesi = OLD.id_sesi
$$
DELIMITER ;


ALTER TABLE `hasil_test`
  ADD CONSTRAINT `hasil_test_ibfk_1` FOREIGN KEY (`id_peserta`) REFERENCES `peserta` (`id_peserta`),
  ADD CONSTRAINT `hasil_test_ibfk_2` FOREIGN KEY (`id_sesi`) REFERENCES `sesi_test` (`id_sesi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
