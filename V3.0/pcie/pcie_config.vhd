---------------------------------------------------------------------------------------------------
--
-- Title       : pcie_config
-- Design      : ring bus
-- Author      : Zhao Ming
-- Company     : a4a881d4
--
---------------------------------------------------------------------------------------------------
--
-- File        : pcie_config.vhd
-- Generated   : 2013/9/15
-- From        : 
-- By          : 
--
---------------------------------------------------------------------------------------------------
--
-- Description : some pcie constant
--
-- Rev: 3.1
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pcie_config is
	
constant TX_CPLD_FMT_TYPE        : std_logic_vector(6 downto 0) := "1001010";
constant TX_CPL_FMT_TYPE         : std_logic_vector(6 downto 0) := "0001010";
constant RX_MEM_RD32_FMT_TYPE    : std_logic_vector(6 downto 0) := "0000000"; 
constant RX_MEM_WR32_FMT_TYPE    : std_logic_vector(6 downto 0) := "1000000"; 
constant RX_MEM_RD64_FMT_TYPE    : std_logic_vector(6 downto 0) := "0100000"; 
constant RX_MEM_WR64_FMT_TYPE    : std_logic_vector(6 downto 0) := "1100000";
constant RX_IO_RD32_FMT_TYPE     : std_logic_vector(6 downto 0) := "0000010"; 
constant RX_IO_WR32_FMT_TYPE     : std_logic_vector(6 downto 0) := "1000010"; 

constant Device_TC            : std_logic_vector(2 downto 0) := "000";
constant Device_TD            : std_logic:='0';
constant Device_EP            : std_logic:='0';
constant Device_ATTR          : std_logic_vector(1 downto 0)  := "00";
constant Device_WR_TAG        : std_logic_vector(7 downto 0)  := "00000000";

component endpoint_blk_plus_v1_15
  port (
    pci_exp_rxn : in std_logic_vector((1 - 1) downto 0);
    pci_exp_rxp : in std_logic_vector((1 - 1) downto 0);
    pci_exp_txn : out std_logic_vector((1 - 1) downto 0);
    pci_exp_txp : out std_logic_vector((1 - 1) downto 0);

    sys_clk : in STD_LOGIC;
    sys_reset_n : in STD_LOGIC;

    refclkout         : out std_logic;


    trn_clk : out STD_LOGIC; 
    trn_reset_n : out STD_LOGIC; 
    trn_lnk_up_n : out STD_LOGIC; 

    trn_td : in STD_LOGIC_VECTOR((64 - 1) downto 0);
    trn_trem_n: in STD_LOGIC_VECTOR (7 downto 0);
    trn_tsof_n : in STD_LOGIC;
    trn_teof_n : in STD_LOGIC;
    trn_tsrc_dsc_n : in STD_LOGIC;
    trn_tsrc_rdy_n : in STD_LOGIC;
    trn_tdst_dsc_n : out STD_LOGIC;
    trn_tdst_rdy_n : out STD_LOGIC;
    trn_terrfwd_n : in STD_LOGIC ;
    trn_tbuf_av : out STD_LOGIC_VECTOR (( 4 -1 ) downto 0 );

    trn_rd : out STD_LOGIC_VECTOR((64 - 1) downto 0);
    trn_rrem_n: out STD_LOGIC_VECTOR (7 downto 0);
    trn_rsof_n : out STD_LOGIC;
    trn_reof_n : out STD_LOGIC; 
    trn_rsrc_dsc_n : out STD_LOGIC; 
    trn_rsrc_rdy_n : out STD_LOGIC; 
    trn_rbar_hit_n : out STD_LOGIC_VECTOR ( 6 downto 0 );
    trn_rdst_rdy_n : in STD_LOGIC; 
    trn_rerrfwd_n : out STD_LOGIC; 
    trn_rnp_ok_n : in STD_LOGIC; 
    trn_rfc_npd_av : out STD_LOGIC_VECTOR ( 11 downto 0 ); 
    trn_rfc_nph_av : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    trn_rfc_pd_av : out STD_LOGIC_VECTOR ( 11 downto 0 ); 
    trn_rfc_ph_av : out STD_LOGIC_VECTOR ( 7 downto 0 );
    trn_rcpl_streaming_n      : in STD_LOGIC;

    cfg_do : out STD_LOGIC_VECTOR ( 31 downto 0 );
    cfg_rd_wr_done_n : out STD_LOGIC; 
    cfg_di : in STD_LOGIC_VECTOR ( 31 downto 0 ); 
    cfg_byte_en_n : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    cfg_dwaddr : in STD_LOGIC_VECTOR ( 9 downto 0 );
    cfg_wr_en_n : in STD_LOGIC;
    cfg_rd_en_n : in STD_LOGIC; 

    cfg_err_cor_n : in STD_LOGIC; 
    cfg_err_cpl_abort_n : in STD_LOGIC; 
    cfg_err_cpl_timeout_n : in STD_LOGIC; 
    cfg_err_cpl_unexpect_n : in STD_LOGIC; 
    cfg_err_ecrc_n : in STD_LOGIC; 
    cfg_err_posted_n : in STD_LOGIC; 
    cfg_err_tlp_cpl_header : in STD_LOGIC_VECTOR ( 47 downto 0 ); 
    cfg_err_ur_n : in STD_LOGIC;
    cfg_err_cpl_rdy_n : out STD_LOGIC;
    cfg_err_locked_n : in STD_LOGIC; 
    cfg_interrupt_n : in STD_LOGIC;
    cfg_interrupt_rdy_n : out STD_LOGIC;
    cfg_pm_wake_n : in STD_LOGIC;
    cfg_pcie_link_state_n : out STD_LOGIC_VECTOR ( 2 downto 0 ); 
    cfg_to_turnoff_n : out STD_LOGIC;
    cfg_interrupt_assert_n : in  STD_LOGIC;
    cfg_interrupt_di : in  STD_LOGIC_VECTOR(7 downto 0);
    cfg_interrupt_do : out STD_LOGIC_VECTOR(7 downto 0);
    cfg_interrupt_mmenable : out STD_LOGIC_VECTOR(2 downto 0);
    cfg_interrupt_msienable: out STD_LOGIC;

    cfg_trn_pending_n : in STD_LOGIC;
    cfg_bus_number : out STD_LOGIC_VECTOR ( 7 downto 0 );
    cfg_device_number : out STD_LOGIC_VECTOR ( 4 downto 0 );
    cfg_function_number : out STD_LOGIC_VECTOR ( 2 downto 0 );
    cfg_status : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_command : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_dstatus : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_dcommand : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_lstatus : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_lcommand : out STD_LOGIC_VECTOR ( 15 downto 0 );
    cfg_dsn: in STD_LOGIC_VECTOR (63 downto 0 );

    fast_train_simulation_only : in STD_LOGIC

  );

end component;
	
end rb_config;
